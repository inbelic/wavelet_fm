defmodule WaveletFMWeb.Radio do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFM.FMs.FM
  alias WaveletFM.FMs.Follow
  alias WaveletFM.Posts
  alias WaveletFM.Posts.Reaction
  alias WaveletFMWeb.Components.PostsComponent

  def mount(_params, _session, socket) do
    following =
      socket.assigns.current_fm
      |> FMs.list_following()
      |> Enum.map(fn %Follow{} = follow -> follow.to end)

    fms =
      FMs.list_fms()
      |> Enum.filter(fn fm -> Enum.member?(following, fm.id) end)
      |> Enum.filter(fn fm -> Enum.count(fm.posts) > 0 end)
      |> Enum.map(fn fm ->
        fm
        |> Map.put(:index, 0)
      end)

    indexing =
      fms
      |> Enum.reduce(%{}, fn fm, acc -> Map.put(acc, fm.id, 0) end)

    reactions =
      fms
      |> Enum.reduce(%{}, fn fm, acc ->
        reaction =
          fm.posts
          |> Enum.at(0) # safe given Enum.count(fm.posts) > 0 restriction
          |> Posts.get_reaction(fm)
        Map.put(acc, fm.id, reaction)
      end)

    fms = Enum.map(fms, fn fm -> set_reactions(fm, reactions) end)

    socket =
      socket
      |> stream(:fms, fms)
      |> assign(:indexing, indexing)
      |> assign(:reactions, reactions)

    {:ok, socket}
  end

  def handle_event("prev", %{"fm_id" => fm_id}, socket) do
    fm = fm_id |> FMs.get_fm()

    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> rem(x - 1, Enum.count(fm.posts)) end)

    fm = fm |> set_index(indexing) |> set_reactions(socket.assigns.reactions)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end

  def handle_event("next", %{"fm_id" => fm_id}, socket) do
    fm = fm_id |> FMs.get_fm()

    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> rem(x + 1, Enum.count(fm.posts)) end)

    fm = fm |> set_index(indexing) |> set_reactions(socket.assigns.reactions)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end
  
  def handle_event("react", values, socket) do
    %{"type" => type, "fm_id" => fm_id, "post_id" => post_id} = values

    reaction_type = case type do
      "love" -> :love
      "heat" -> :heat
    end
      
    fm = fm_id |> FMs.get_fm()
    post = post_id |> Posts.get_post!()

    reaction = Posts.get_reaction(post, fm)
    exists = reaction.love || reaction.heat

    {:ok, reaction} =
      reaction
      |> Map.update!(reaction_type, fn x -> !x end)
      |> case do
        %Reaction{love: false, heat: false} = reaction ->
          Posts.delete_reaction(reaction)
        %Reaction{love: love, heat: heat} when exists ->
          Posts.update_reaction(reaction, %{love: love, heat: heat})
        %Reaction{love: love, heat: heat} ->
          Posts.create_reaction(fm, post, %{love: love, heat: heat})
      end

    reactions =
      socket.assigns.reactions
      |> Map.put(fm_id, reaction)

    fm = fm |> set_index(socket.assigns.indexing) |> set_reactions(reactions)

    socket =
      socket
      |> assign(:reactions, reactions)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end

  defp set_index(%FM{} = fm, indexing) do
    idx = Map.fetch!(indexing, fm.id)
    Map.put(fm, :index, idx)
  end

  # WARNING: that set_reactions is dependent on running set_index first
  defp set_reactions(%FM{} = fm, reactions) do
    reaction = Map.fetch!(reactions, fm.id)
    fm
    |> Map.put(:love, reaction.love)
    |> Map.put(:heat, reaction.heat)
  end
end
