defmodule WaveletFMWeb.Host do
  use WaveletFMWeb, :live_view

  alias WaveletFM.Wavelets
  alias WaveletFM.Wavelets.Wavelet
  alias WaveletFMWeb.Components.HostWaveletsComponent

  alias WaveletFM.Posts
  alias WaveletFM.FMs

  alias External.Spotify

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(check_errors: false)
      |> assign(spotify: %Spotify{})

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_params(_params, _uri, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{})

    wavelets =
      socket.assigns.current_user
      |> FMs.get_fm_by_user()
      |> Wavelets.get_wavelets_by_fm()
      |> append_empties(5)
      |> Enum.with_index(fn element, index -> {index, element} end)

    socket =
      socket
      |> assign(wid: nil)
      |> assign(wavelets: wavelets)
      |> assign(search_wavelets: [])
      |> assign_form(changeset)

    {:noreply, socket}
  end
  
  def handle_event("selected", %{"wid" => cur_wid}, socket) do
    case socket.assigns.wid do
      nil ->
        {:noreply, assign(socket, wid: cur_wid)}
      wid ->
        # Determine the wavelet that will be replaced from the users fm
        {_, replace_wavelet} = Enum.at(socket.assigns.wavelets, wid)

        current_fm = socket.assigns.current_user |> FMs.get_fm_by_user()

        # If the wavelet is not an empty one, then delete the parent post
        {:ok, _} =
          current_fm
          |> Posts.get_posts_by_fm()
          |> Enum.find(fn post ->
            post.wavelet == replace_wavelet.id
          end)
          |> case do
            nil -> {:ok, nil}
            post -> Posts.delete_post(post)
          end

        # Create a new post on the users fm with the selected search wavelet
        # values
        {_, searched_wavelet} = Enum.at(socket.assigns.search_wavelets, cur_wid)
        {:ok, wavelet} = Wavelets.create_wavelet(searched_wavelet)
        Posts.create_post(current_fm, wavelet)

        {:noreply, push_patch(socket, to: ~p"/host")}
    end
  end

  def handle_event("validate", %{"wavelet" => wavelet_params}, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{}, wavelet_params |> default_attrs)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end
  
  def handle_event("search", %{"wavelet" => wavelet_params}, socket) do
    %{"title" => title, "artist" => artist} = wavelet_params
    {:ok, spotify, search_wavelets} =
      Spotify.track_search(socket.assigns.spotify, title, artist)

    search_wavelets =
      Enum.with_index(search_wavelets, fn element, index -> {index, element} end)

    changeset = Wavelets.change_wavelet(%Wavelet{}, wavelet_params |> default_attrs)
    socket =
      socket
      |> assign(search_wavelets: search_wavelets)
      |> assign(spotify: spotify)
      |> assign_form(changeset)
    {:noreply, socket}
  end

  # Helper functions for the handle_event functions

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "wavelet")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  defp default_attrs(attrs) do
    attrs
    |> Map.put_new("cover", "")
    |> Map.put_new("links", [])
  end

  defp empty_wavelet() do
    %Wavelet{id: nil, title: "Not Selected", artist: "", cover: "", links: []}
  end

  defp append_empties(list, num) when num <= length(list) do
    list
  end

  defp append_empties(list, num) do
    to_take = max(0, num - length(list))
    list ++ Enum.map(1..to_take, fn _ -> empty_wavelet() end)
  end
end
