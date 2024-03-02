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
        <div class="reaction-links-container">
          <%= if @show_reactions == "true" do %>
            <.live_component
              module = {ReactionComponent}
              fm={@fm}
              id={@id <> "-reactions"}
              post={@post}
            />
          <% end %>
          <% spotify_link = Enum.at(@wavelet.links, 0) %>
          <a href={spotify_link} target="_blank" class="">
            <img src="/images/spotify_icon.png" alt="Spotify Link" class="spotify-icon" />
          </a>
        </div>
      </div>
    </div>
    """
  end
end
