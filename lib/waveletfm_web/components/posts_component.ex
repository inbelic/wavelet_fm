defmodule WaveletFMWeb.Components.PostsComponent do
  use WaveletFMWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="fm-feed" phx-update="stream" class="">
      <div :for={{dom_id, fm} <- @fms} id={dom_id} class="post-container mt-3">
        <div class="fm-container">
          <%= fm.freq %> <%= fm.username %> FM
        </div>
        <div class="wavelet-container">
        </div>
      </div>
    </div>
    """
  end
end
