defmodule WaveletFMWeb.Host do
  use WaveletFMWeb, :live_view

  alias WaveletFM.Wavelets
  alias WaveletFM.Wavelets.Wavelet
  alias WaveletFMWeb.Components.HostWaveletsComponent

  def mount(_params, _session, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{})

    temp_wavelet = %Wavelet{id: "ok", title: "As It Was",
      artist: "Harry Styles",
      cover: "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
      links: []}
    wavelets =
      [temp_wavelet, temp_wavelet]
      |> Enum.with_index(fn element, index -> {index, element} end)

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign(wid: nil, wavelets: wavelets)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end
  
  def handle_event("selected", %{"wid" => wid}, socket) do
    {:noreply, assign(socket, wid: wid)}
  end

  def handle_event("validate", %{"wavelet" => wavelet_params}, socket) do
    changeset = Wavelets.change_wavelet(%Wavelet{}, wavelet_params |> default_attrs)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end
  
  def handle_event("save", %{"wavelet" => wavelet_params}, socket) do
    case Wavelets.create_wavelet(wavelet_params |> default_attrs) do
      {:ok, wavelet} ->
        changeset = Wavelets.change_wavelet(wavelet, wavelet_params |> default_attrs)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

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
    |> Map.put_new("cover", "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228")
    |> Map.put_new("links", [])
  end
end
