defmodule WaveletFMWeb.Host do
  use WaveletFMWeb, :live_view

  alias WaveletFM.Wavelets
  alias WaveletFM.Wavelets.Wavelet
  alias WaveletFMWeb.Components.HostWaveletsComponent

  alias WaveletFM.Posts
  alias WaveletFM.FMs

  alias External.GenWavelets

  def mount(_params, _session, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{})

    socket =
      socket
      |> assign(check_errors: false)
      |> assign(wid: nil)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_params(_params, _uri, socket) do
    wavelets =
      socket.assigns.current_user
      |> FMs.get_fm_by_user()
      |> Wavelets.get_wavelets_by_fm()
      |> append_empty()
      |> Enum.with_index(fn element, index -> {index, element} end)

    {:noreply, socket |> assign(wavelets: wavelets) |> assign(search_wavelets: [])}
  end
  
  def handle_event("selected", %{"wid" => cur_wid}, socket) do
    case socket.assigns.wid do
      nil ->
        {:noreply, assign(socket, wid: cur_wid)}
      wid ->
        {_, replace_wavelet} = Enum.at(socket.assigns.wavelets, wid)
        {:ok, _} = case replace_wavelet.id do
          nil -> {:ok, :ok}
          _ -> Wavelets.delete_wavelet(replace_wavelet)
        end

        {_, searched_wavelet} = Enum.at(socket.assigns.search_wavelets, cur_wid)
        Wavelets.create_wavelet(searched_wavelet)

        {:noreply, push_patch(socket, to: ~p"/host")}
    end
  end

  def handle_event("validate", %{"wavelet" => wavelet_params}, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{}, wavelet_params |> default_attrs)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end
  
  def handle_event("search", %{"wavelet" => wavelet_params}, socket) do
    %{"title" => title, "artist" => artist} = wavelet_params
    search_wavelets =
      GenWavelets.gen_search(title, artist)
      |> Enum.with_index(fn element, index -> {index, element} end)

    changeset = Wavelets.change_wavelet(%Wavelet{}, wavelet_params |> default_attrs)
    socket =
      socket
      |> assign(search_wavelets: search_wavelets)
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

  defp append_empty(list) do
    to_take = max(0, 5 - length(list))
    list ++ Enum.map(1..to_take, fn _ -> empty_wavelet() end)
  end

  defp replace_selected(wavelets, wid, replacement_wavelet) do
    Enum.map(wavelets,
      fn {cur_wid, wavelet} ->
        if cur_wid == wid do replacement_wavelet
        else wavelet
        end
      end)
  end
end
