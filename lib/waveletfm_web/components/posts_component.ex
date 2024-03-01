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
        <div class="follow" phx-click="follow" phx-value-fm_id={fm.id}>
          <div class="follow-non">
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#FF6961" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
            </svg>
          </div>
          <div class="follow-on">
            <svg viewBox="0 0 24 24" fill="#FF6961" class="w-6 h-6">
              <path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25ZM12.75 9a.75.75 0 0 0-1.5 0v2.25H9a.75.75 0 0 0 0 1.5h2.25V15a.75.75 0 0 0 1.5 0v-2.25H15a.75.75 0 0 0 0-1.5h-2.25V9Z" clip-rule="evenodd" />
            </svg>
          </div>
        </div>
        </div>
        <div class="button-container">
          <button phx-click="prev" phx-value-fm_id={fm.id}>
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="black" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
            </svg>
          </button>
        <div class="wavelet-container">
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
