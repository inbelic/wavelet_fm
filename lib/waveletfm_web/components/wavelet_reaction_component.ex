defmodule WaveletFMWeb.Components.WaveletReactionComponent do
  use WaveletFMWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="wavelet-reactions">
      <% js = {JS.push("bad", value: %{wavelet: "hello"})} %>
      <div class="phx-click={js} reaction-icon flex">
        <svg viewBox="0 0 24 24" fill="#FF6961" class="w-6 h-6">
          <path d="m11.645 20.91-.007-.003-.022-.012a15.247 15.247 0 0 1-.383-.218 25.18 25.18 0 0 1-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0 1 12 5.052 5.5 5.5 0 0 1 16.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 0 1-4.244 3.17 15.247 15.247 0 0 1-.383.219l-.022.012-.007.004-.003.001a.752.752 0 0 1-.704 0l-.003-.001Z" />
        </svg>
        <%= @wavelet.love %>
      </div>
      <div class="phx-click={js} reaction-icon flex ml-1">
        <svg viewBox="0 0 24 24" fill="#FF6961" class="w-6 h-6">
          <path fill-rule="evenodd" d="M12.963 2.286a.75.75 0 0 0-1.071-.136 9.742 9.742 0 0 0-3.539 6.176 7.547 7.547 0 0 1-1.705-1.715.75.75 0 0 0-1.152-.082A9 9 0 1 0 15.68 4.534a7.46 7.46 0 0 1-2.717-2.248ZM15.75 14.25a3.75 3.75 0 1 1-7.313-1.172c.628.465 1.35.81 2.133 1a5.99 5.99 0 0 1 1.925-3.546 3.75 3.75 0 0 1 3.255 3.718Z" clip-rule="evenodd" />
        </svg>
        <%= @wavelet.heat %>
      </div>
    </div>
    """
  end
end
