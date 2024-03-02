defmodule WaveletFMWeb.Components.WaveletComponent do
  use WaveletFMWeb, :live_component

  alias WaveletFMWeb.Components.ReactionComponent

  def render(assigns) do
    ~H"""
    <div class="wavelet-container">
      <div class="wavelet-cover">
        <div class="cover-wrapper">
          <img src={@wavelet.cover} alt="Cover Art"/>
        </div>
      </div>
      <div class="wavelet-sub-container">
        <div phx-click={JS.toggle_class("scrolling")}
              class="wavelet-text scroll-text text-lg ml-1">
          <bold><%= @wavelet.title %></bold>
        </div>
        <div class="wavelet-text text-sm ml-2">
        <%= if @wavelet.artist != "" do %> by <% end %><%= @wavelet.artist %>
        </div>
        <.live_component
           module = {ReactionComponent}
           id={@id <> "-reactions"}
           post={@post}
        />
      </div>
    </div>
    """
  end
end
