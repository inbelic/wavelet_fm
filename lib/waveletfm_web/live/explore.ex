defmodule WaveletFMWeb.Explore do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFMWeb.Components.PostsComponent

  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:fms, FMs.list_fms())

    {:ok, socket}
  end
end
