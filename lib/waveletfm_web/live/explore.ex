defmodule WaveletFMWeb.Explore do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFMWeb.Components.PostsComponent

  def mount(_params, _session, socket) do
    fms =
      FMs.list_fms()
      |> Enum.filter(fn fm -> Enum.count(fm.posts) > 0 end)

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

    fm = FMs.get_fm!(fm_id)

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
