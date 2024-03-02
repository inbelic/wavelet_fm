defmodule WaveletFMWeb.UserSettingsLive do
  use WaveletFMWeb, :live_view

  alias WaveletFM.Accounts
  alias WaveletFM.FMs

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account settings</:subtitle>
    </.header>

    <div class="space-y-12 divide-y">
      <div>
        <.simple_form
          for={@fm_form}
          id="fm_form"
          phx-submit="update_fm"
          phx-change="validate_fm"
        >
          <.input field={@fm_form[:freq]} type="number" label="FM Frequency" step="0.1" required />
          <.input field={@fm_form[:username]} type="text" label="FM Username" required />
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Profile Picture
          </label>
          <div style="margin-top: 0" phx-drop-target={@uploads.profile.ref}>
            <.live_file_input upload={@uploads.profile} />
          </div>
          <.input field={@fm_form[:rmv_profile]} type="checkbox" label="Remove Profile Picture" />

          <.input
            field={@fm_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@fm_form_current_password}
            required
          />

          <:actions>
            <.button phx-disable-with="Changing...">Change FM</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@email_form}
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            field={@password_form[:email]}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    fm = user |> FMs.get_fm_by_user()
    fm_changeset = FMs.change_fm(fm)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)
      |> assign(:fm_form, to_form(fm_changeset))
      |> assign(:fm_form_current_password, nil)
      |> assign(:uploaded_files, [])
      |> allow_upload(:profile, accept: ~w(.jpg .jpeg .png), max_entries: 1)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("validate_fm", params, socket) do
    %{"current_password" => password, "fm" => fm_params} = params

    fm = socket.assigns.current_user |> FMs.get_fm_by_user()
    fm_form =
      fm
      |> FMs.change_fm(fm_params, validate_fm: false)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, fm_form: fm_form, fm_form_current_password: password)}
  end

  def handle_event("update_fm", params, socket) do
    %{"current_password" => password, "fm" => fm_params} = params
    user = socket.assigns.current_user
    fm = user |> FMs.get_fm_by_user()
    dest = Path.join(Application.app_dir(:waveletfm, "priv/static/uploads"), fm.id)

    uploaded_files =
      consume_uploaded_entries(socket, :profile, fn %{path: path}, entry ->
        ext_type = case entry.client_type do
          "image/jpg" -> ".jpg"
          "image/png" -> ".png"
          "image/jpeg" -> ".jpeg"
        end
        img_dest = dest <> ext_type
        {:ok, image} = Image.open(path)
        {:ok, image} = Image.thumbnail(image, 200, crop: :attention)
        Image.write(image, img_dest)
        File.rename!(img_dest, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    fm_params =
      case get_action(uploaded_files, fm_params["rmv_profile"]) do
        :non -> fm_params
        :rmv ->
          File.rm(dest)
          Map.put(fm_params, "profiled", false)
        :add -> Map.put(fm_params, "profiled", true)
      end

    case FMs.update_fm(fm, user, password, fm_params) do
      {:ok, _fm} ->
        info = "FM successfully updated."
        {:noreply, socket |> put_flash(:info, info) |> assign(fm_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :fm_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  defp get_action([], "true") do
    :rmv # no uploaded photo and request to remove profile pic
  end

  defp get_action([], "false") do
    :non # no uploaded photo and no request to remove profile pic
  end

  defp get_action(_, _) do
    :add # uploaded photo so will replace the existing wheter rmv_profile is selected or not
  end

  defp error_to_string(:too_large), do: "Selected file is too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "Only file types allowed are jpg, jpeg and png"
end
