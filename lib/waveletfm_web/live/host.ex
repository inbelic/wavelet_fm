defmodule WaveletFMWeb.Host do
  use WaveletFMWeb, :live_view

  alias WaveletFM.FMs
  alias WaveletFM.Wavelets
  alias WaveletFM.Wavelets.Wavelet
  alias WaveletFMWeb.Components.StreamWaveletsComponent

  alias WaveletFM.Posts

  alias External.Spotify

  def mount(_params, _session, socket) do
    fm = FMs.get_fm(socket.assigns.current_fm.id)
    posts = fm.posts |> Enum.sort_by(fn p -> p.inserted_at end)

    reactions =
      posts
      |> Enum.map(fn post -> Posts.tally_reactions(post) end)
      |> Enum.map(fn x -> Enum.map(x,
        fn {key, val} -> if val do {key, val} else {key, 0} end end)
      end)
      |> append_empties(empty_reaction(), 5)

    wavelets =
      posts
      |> Enum.sort(fn px, py -> px.inserted_at >= py.inserted_at end)
      |> Enum.map(fn post -> post.wavelet end)
      |> append_empties(empty_wavelet(), 5)

    wavelets =
      Enum.zip(wavelets, reactions)
      |> Enum.map(fn {wavelet, reaction} -> set_reactions(wavelet, reaction) end)

    socket =
      socket
      |> assign(check_errors: false)
      |> assign(spotify: %Spotify{})
      |> stream(:wavelets, wavelets)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_params(_params, _uri, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{})

    socket =
      socket
      |> assign(wavelet: nil)
      |> stream(:search_wavelets, [], reset: true)
      |> assign_form(changeset)

    {:noreply, socket}
  end

  def handle_event("data-cancel", %{}, socket) do
    socket =
      socket
      |> assign(wavelet: nil)
    {:noreply, socket}
  end
  
  def handle_event("selected", %{"wavelet" => json_wavelet}, socket) do
    case {socket.assigns.current_user.confirmed_at, socket.assigns.wavelet} do
      {nil, _} ->
        socket =
          socket
          |> put_flash(:error, "You must confirm your account before broadcasting.")
        {:noreply, socket}
      {_, nil} ->
        replace_wavelet = to_wavelet(json_wavelet)
        set_replacement(socket, replace_wavelet)
      {_, replace_wavelet} ->
        searched_wavelet = to_wavelet(json_wavelet)
        replace_wavelet(socket, replace_wavelet, searched_wavelet)
    end
  end

  def handle_event("validate", %{"wavelet" => wavelet_params}, socket) do
    changeset = Wavelets.change_search_wavelet(%Wavelet{}, wavelet_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end
  
  def handle_event("search", %{"wavelet" => wavelet_params}, socket) do
    %{"title" => title, "artist" => artist} = wavelet_params
    {:ok, spotify, search_wavelets} =
      Spotify.track_search(socket.assigns.spotify, title, artist)

    changeset = Wavelets.change_search_wavelet(%Wavelet{}, wavelet_params)
    socket =
      socket
      |> stream(:search_wavelets, search_wavelets, reset: true)
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

  defp set_replacement(socket, replace_wavelet) do
    posts = socket.assigns.current_fm |> Posts.get_posts_by_fm()
    if Enum.count(posts) < 5 do
      socket =
        socket
        |> push_event("search-modal", %{on: true})
        |> assign(wavelet: replace_wavelet)
      {:noreply, socket}
    else
      post = Enum.at(posts, 0)
      {:ok, current_time} = DateTime.now("Etc/UTC")
      diff = DateTime.diff(current_time, post.inserted_at, :hour)
      if diff < 24 do
        socket =
          socket
          |> put_flash(:error, "You must wait #{24 - diff} hours until your next update.")
        {:noreply, socket}
      else
        socket =
          socket
          |> push_event("search-modal", %{on: true})
          |> assign(wavelet: replace_wavelet)
        {:noreply, socket}
      end
    end
  end

  defp replace_wavelet(socket, replace_wavelet, searched_wavelet) do
    # If the wavelet is not an empty one, then delete the parent post
    {:ok, _} =
      socket.assigns.current_fm
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
    {:ok, wavelet} = Wavelets.create_wavelet(searched_wavelet)
    {:ok, _post} = Posts.create_post(socket.assigns.current_fm, wavelet)
    wavelet = set_reactions(wavelet, empty_reaction())

    socket =
      socket
      |> stream_delete(:wavelets, replace_wavelet)
      |> stream_insert(:wavelets, wavelet, at: 0)
      |> push_event("search-modal", %{on: false})

    {:noreply, push_patch(socket, to: ~p"/host")}
  end


  defp empty_wavelet() do
    %Wavelet{id: "empty", title: "Not Selected", artist: "",
      cover: ~p"/images/empty_wavelet.svg", links: []}
  end

  defp empty_reaction(), do: []

  defp append_empties(list, _el, num) when num <= length(list) do
    list
  end

  defp append_empties(list, el, num) do
    to_take = max(0, num - length(list))
    list ++ Enum.map(1..to_take, fn _ -> el end)
  end

  defp to_wavelet(params) do
    %{"id" => id, "title" => title, "artist" => artist} = params
    %{"cover" => cover, "links" => links} = params
    %Wavelet{id: id, title: title, artist: artist, cover: cover, links: links}
  end

  defp set_reactions(%Wavelet{} = wavelet, reactions) do
    love = Keyword.get(reactions, :love, 0)
    heat = Keyword.get(reactions, :heat, 0)
    wavelet
    |> Map.put(:love, love)
    |> Map.put(:heat, heat)
  end
end
