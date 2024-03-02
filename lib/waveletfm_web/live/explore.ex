defmodule WaveletFMWeb.Explore do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFM.FMs.FM
  alias WaveletFM.FMs.Follow
  alias WaveletFMWeb.Components.PostsComponent

  def mount(_params, _session, socket) do
    following =
      socket.assigns.current_fm
      |> FMs.list_following()
      |> Enum.map(fn %Follow{} = follow -> follow.to end)

    socket =
      socket
      |> assign(:following, following)
      |> assign(:form, to_form(%{"search" => ""}))
      |> assign(:search, "")

    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    fms =
      FMs.list_fms(socket.assigns.search)
      |> Enum.filter(fn fm -> Enum.count(fm.posts) > 0 end)
      |> Enum.map(fn fm ->
        fm
        |> Map.put(:following, Enum.member?(socket.assigns.following, fm.id))
        |> Map.put(:index, 0)
      end)

    indexing =
      fms
      |> Enum.reduce(%{}, fn fm, acc -> Map.put(acc, fm.id, 0) end)

    socket =
      socket
      |> stream(:fms, fms, reset: true)
      |> assign(:indexing, indexing)

    {:noreply, socket}
  end

  def handle_event("update", %{"search" => search}, socket) do
    socket =
      socket
      |> assign(:form, to_form(%{"search" => search}))
      |> assign(:search, search)
      |> push_patch(to: ~p"/explore")

    {:noreply, socket}
  end

  def handle_event("follow", %{"fm_id" => fm_id}, socket) do
    from_fm = FMs.get_fm(socket.assigns.current_fm.id)
    to_fm = FMs.get_fm(fm_id)

    following =
      FMs.follow_id(from_fm.id, to_fm.id)
      |> FMs.get_follow()
      |> case do
        nil ->
          {:ok, follow} = FMs.create_follow(from_fm, to_fm)
          [follow.to | socket.assigns.following]
        follow ->
          {:ok, follow} = FMs.delete_follow(follow)
          Enum.reject(socket.assigns.following,
            fn f_id -> f_id == follow.to end)
      end

    to_fm =
      to_fm
      |> set_following(following)
      |> set_index(socket.assigns.indexing)

    socket =
      socket
      |> stream_insert(:fms, to_fm)
      |> assign(:following, following)

    {:noreply, socket}
  end

  def handle_event("prev", %{"fm_id" => fm_id}, socket) do
    fm = fm_id |> FMs.get_fm()

    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> rem(x - 1, Enum.count(fm.posts)) end)

    fm = fm
      |> set_following(socket.assigns.following)
      |> set_index(indexing)

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

    fm = fm
      |> set_following(socket.assigns.following)
      |> set_index(indexing)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end

  defp set_following(%FM{} = fm, following) do
    Map.put(fm, :following, Enum.member?(following, fm.id))
  end

  defp set_index(%FM{} = fm, indexing) do
    idx = Map.fetch!(indexing, fm.id)
    Map.put(fm, :index, idx)
  end
end
