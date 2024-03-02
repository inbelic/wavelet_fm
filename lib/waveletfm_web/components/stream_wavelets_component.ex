defmodule WaveletFMWeb.Components.StreamWaveletsComponent do
  use WaveletFMWeb, :live_component

  alias WaveletFMWeb.Components.WaveletReactionComponent

  defp random_id, do: Integer.to_string(Enum.random(0..1_000_000))

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
              <%= if @show_reactions do %>
                <.live_component
                  module = {WaveletReactionComponent}
                  id={dom_id <> random_id()}
                  wavelet={wavelet}
                />
              <% end %>
            </div>
          </div>
        </div>
        <div style="height: 0.7rem">
        </div>
    </div>
    """
  end
end
