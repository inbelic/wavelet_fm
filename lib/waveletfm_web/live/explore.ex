defmodule WaveletFMWeb.Explore do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFM.FMs.Follow
  alias WaveletFMWeb.Components.PostsComponent

  def mount(_params, _session, socket) do
    fms =
      FMs.list_fms()
      |> Enum.filter(fn fm -> Enum.count(fm.posts) > 0 end)

    indexing =
      fms
      |> Enum.reduce(%{}, fn fm, acc -> Map.put(acc, fm.id, 0) end)

    following =
      socket.assigns.current_fm
      |> FMs.list_following()
      |> Enum.map(fn %Follow{} = follow -> follow.to end)

    socket =
      socket
      |> stream(:fms, fms)
      |> assign(:following, following)
      |> assign(:indexing, indexing)

    {:ok, socket}
  end

  def handle_event("follow", %{"fm_id" => fm_id}, socket) do
    from_fm = FMs.get_fm(socket.assigns.current_fm.id)
    to_fm = FMs.get_fm!(fm_id)

    following =
      FMs.follow_id(from_fm.id, to_fm.id)
      |> FMs.get_follow()
      |> case do
        nil ->
          {:ok, follow} = FMs.create_follow(from_fm, to_fm)
          [follow | socket.assigns.following]
        follow ->
          {:ok, follow} = FMs.delete_follow(follow)
          Enum.reject(socket.assigns.following,
            fn f_id -> f_id == follow.id end)
      end

    socket =
      socket
      |> assign(:following, following)

    {:noreply, socket}
  end

  def handle_event("prev", %{"fm_id" => fm_id}, socket) do
    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> x - 1 end)

    fm = FMs.get_fm(fm_id)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)
    {:noreply, socket}
  end

  def handle_event("next", %{"fm_id" => fm_id}, socket) do
    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> x + 1 end)

    fm = FMs.get_fm(fm_id)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end
end
