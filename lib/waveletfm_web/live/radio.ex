defmodule WaveletFMWeb.Radio do
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

    fms =
      FMs.list_fms()
      |> Enum.filter(fn fm -> Enum.count(fm.posts) > 0 end)
      |> Enum.filter(fn fm -> Enum.member?(following, fm.id) end)
      |> Enum.map(fn fm ->
        fm
        |> Map.put(:index, 0)
      end)

    indexing =
      fms
      |> Enum.reduce(%{}, fn fm, acc -> Map.put(acc, fm.id, 0) end)

    socket =
      socket
      |> stream(:fms, fms)
      |> assign(:indexing, indexing)

    {:ok, socket}
  end

  def handle_event("prev", %{"fm_id" => fm_id}, socket) do
    indexing =
      socket.assigns.indexing
      |> Map.update!(fm_id, fn x -> x - 1 end)

    fm =
      fm_id
      |> FMs.get_fm()
      |> set_index(indexing)

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

    fm =
      fm_id
      |> FMs.get_fm()
      |> set_index(indexing)

    socket =
      socket
      |> assign(:indexing, indexing)
      |> stream_insert(:fms, fm)

    {:noreply, socket}
  end

  defp set_index(%FM{} = fm, indexing) do
    idx = Map.fetch!(indexing, fm.id)
    Map.put(fm, :index, idx)
  end
end
