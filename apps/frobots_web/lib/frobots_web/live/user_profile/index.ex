defmodule FrobotsWeb.UserProfileLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Api, Avatars, ChangesetError}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    s3_base_url = Api.get_s3_base_url()

    {:ok,
     socket
     |> assign(:user, current_user)
     |> assign(:username, get_user_name(current_user))
     |> assign(:s3_base_url, s3_base_url)
     |> assign(:avatars, Avatars.list_user_avatars())}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_event("react.get_user_profile", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_user_profile", %{
       "user" => destruct_user_details(socket.assigns.user),
       "s3_base_url" => socket.assigns.s3_base_url,
       "user_avatars" => socket.assigns.avatars
     })}
  end

  def handle_event("react.update_user_details", params, socket) do
    case Accounts.update_profile(socket.assigns.user, params) do
      {:ok, updatedUser} ->
        {:noreply,
         push_event(
           socket
           |> assign(:username, get_user_name(updatedUser))
           |> put_flash(:info, "User details updated successfully"),
           "react.return_user_profile",
           %{
             "user" => destruct_user_details(updatedUser),
             "s3_base_url" => socket.assigns.s3_base_url,
             "user_avatars" => socket.assigns.avatars
           }
         )}

      {:_error, changeset} ->
        errors = ChangesetError.translate_errors(changeset)

        {:noreply,
         socket
         |> put_flash(
           :error,
           "Oops, unable to update user! Please check the errors: #{Jason.encode!(errors)}"
         )}
    end
  end

  def handle_event("react.update_user_email", params, socket) do
    IO.inspect(params)
    user = socket.assigns.user
    %{"current_password" => password, "user" => user_params} = params

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_update_email_instructions(
          applied_user,
          user.email,
          &Routes.user_settings_url(socket, :confirm_email, &1)
        )

        {:noreply,
         push_event(
           socket
           |> assign(:username, get_user_name(applied_user))
           |> put_flash(
             :info,
             "A link to confirm your email change has been sent to the new address."
           ),
           "react.return_user_profile",
           %{
             "user" => destruct_user_details(applied_user),
             "s3_base_url" => socket.assigns.s3_base_url,
             "user_avatars" => socket.assigns.avatars
           }
         )}

      {:error, changeset} ->
        errors = ChangesetError.translate_errors(changeset)

        {:noreply,
         socket
         |> put_flash(
           :error,
           "Oops, unable to update email! Please check the errors: #{Jason.encode!(errors)}"
         )}
    end
  end

  def handle_event("react.update_user_password", params, socket) do
    IO.inspect(params)

    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.user

    IO.inspect(user_params)

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        {:noreply,
         push_event(
           socket
           |> assign(:username, get_user_name(user))
           |> put_flash(:info, "Password updated successfully.")
           |> push_redirect(to: "/users/log_in"),
           "react.return_user_profile",
           %{
             "user" => destruct_user_details(user),
             "s3_base_url" => socket.assigns.s3_base_url,
             "user_avatars" => socket.assigns.avatars
           }
         )}

      {:error, changeset} ->
        errors = ChangesetError.translate_errors(changeset)

        {:noreply,
         socket
         |> put_flash(
           :error,
           "Oops, unable to update user password! Please check the errors: #{Jason.encode!(errors)}"
         )}
    end
  end

  def get_user_name(current_user) do
    current_user.name || List.first(String.split(current_user.email, "@"))
  end

  def destruct_user_details(current_user) do
    %{
      "active" => current_user.active,
      "admin" => current_user.admin,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "id" => current_user.id,
      "name" => current_user.name,
      "sparks" => current_user.sparks,
      "inserted_at" => current_user.inserted_at
    }
  end
end
