defmodule WaveletFMWeb.Components.StreamWaveletsComponent do
  use WaveletFMWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="post-feed" phx-update="stream" class="">
      <div :for={{dom_id, wavelet} <- @wavelets} id={dom_id} class="wavelet-container wavelet-hover mt-3"
          phx-click={@js |> JS.push("selected", value: %{wavelet: wavelet})}>
          <div class="wavelet-cover">
            <div class="cover-wrapper">
              <img src={wavelet.cover} alt="Cover Art"/>
            </div>
          </div>
          <div class="wavelet-sub-container">
            <div class="wavelet-text">
            </div>
            <div class="wavelet-text text-lg ml-1">
              <bold><%= wavelet.title %></bold>
            </div>
            <div class="wavelet-text text-sm ml-2">
            <%= if wavelet.artist != "" do %> by <% end %><%= wavelet.artist %>
            </div>
            <div class="wavelet-text">
            </div>
          </div>
        </div>
        <div style="height: 0.7rem">
        </div>
    </div>
    """
  end
end
