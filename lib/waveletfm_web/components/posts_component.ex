defmodule WaveletFMWeb.Components.PostsComponent do
  use WaveletFMWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="fm-feed" phx-update="stream" class="">
      <div :for={{dom_id, fm} <- @fms} id={dom_id} class="post-container mt-3">
        <% idx = rem(@indexing[fm.id], Enum.count(fm.posts)) %>
        <% post = Enum.at(fm.posts, idx) %>
        <% wavelet = post.wavelet %>
        <div class="fm-container">
          <%= fm.freq %> <%= fm.username %> FM
        </div>
        <div class="button-container">
          <button phx-click="prev" phx-value-fm_id={fm.id}>
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="black" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
            </svg>
          </button>
        <div class="wavelet-container">
          <!-- Can use same display of wavelet in host but need assoc first -->
        </div>
        <button phx-click="next" phx-value-fm_id={fm.id}>
          <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="m8.25 4.5 7.5 7.5-7.5 7.5" />
          </svg>
        </button>
        </div>
      </div>
    </div>
    """
  end
end
