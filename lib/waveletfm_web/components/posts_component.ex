defmodule WaveletFMWeb.Components.PostsComponent do
  use WaveletFMWeb, :live_component

  alias WaveletFMWeb.Components.WaveletComponent

  defp assign_class(fm) do
    if fm.following do
      {"follow-on", "follow-non"}
    else
      {"follow-non", "follow-on"}
    end
  end

  def render(assigns) do
    ~H"""
    <div id="fm-feed" phx-update="stream" class="">
      <div :for={{dom_id, fm} <- @fms} id={dom_id} class="post-container mt-3"
        :if={!@current_fm || fm.id != @current_fm.id}>
        <% idx = rem(fm.index, Enum.count(fm.posts)) %>
        <% post = Enum.at(fm.posts, idx) %>
        <% wavelet = post.wavelet %>
        <div class="fm-container">
        <%= if fm.profiled do %>
          <% img_src = "/uploads/" <> fm.id %>
            <div class="profile-img-container">
              <img src={img_src} alt="Profile Picture" class="profile-img" />
            </div>
          <% else %>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="black" class="w-12 h-12">
              <path stroke-linecap="round" stroke-linejoin="round" d="M17.982 18.725A7.488 7.488 0 0 0 12 15.75a7.488 7.488 0 0 0-5.982 2.975m11.963 0a9 9 0 1 0-11.963 0m11.963 0A8.966 8.966 0 0 1 12 21a8.966 8.966 0 0 1-5.982-2.275M15 9.75a3 3 0 1 1-6 0 3 3 0 0 1 6 0Z" />
            </svg>
          <% end %>
          <h1 class="ml-2">
            <%= fm.freq %> <%= fm.username %> FM
          </h1>
          <%= if @current_fm && @show_follow == "true" do %>
            <% {f_outline, f_fill} = assign_class(fm) %>
            <div class="follow" phx-click="follow" phx-value-fm_id={fm.id}>
              <div class={f_outline}>
                <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="#FF6961" class="w-6 h-6">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v6m3-3H9m12 0a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                </svg>
              </div>
              <div class={f_fill}>
                <svg viewBox="0 0 24 24" fill="#FF6961" class="w-6 h-6">
                  <path fill-rule="evenodd" d="M12 2.25c-5.385 0-9.75 4.365-9.75 9.75s4.365 9.75 9.75 9.75 9.75-4.365 9.75-9.75S17.385 2.25 12 2.25ZM12.75 9a.75.75 0 0 0-1.5 0v2.25H9a.75.75 0 0 0 0 1.5h2.25V15a.75.75 0 0 0 1.5 0v-2.25H15a.75.75 0 0 0 0-1.5h-2.25V9Z" clip-rule="evenodd" />
                </svg>
              </div>
            </div>
          <% end %>
        </div>
        <div class="button-container">
          <button phx-click="prev" phx-value-fm_id={fm.id}>
            <svg fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="black" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5 8.25 12l7.5-7.5" />
            </svg>
          </button>
          <.live_component
           module = {WaveletComponent}
            id={dom_id <> "-reactions"}
            wavelet={wavelet}
            post={post}
          />
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
