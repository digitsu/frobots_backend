defmodule FrobotsWeb.UsersLive.FormComponent do
  use FrobotsWeb, :live_component

  alias Frobots.Accounts
  alias Frobots.Accounts.User

  @impl Phoenix.LiveComponent
  def update(%{user: _user} = assigns, socket) do
    changeset = User.registration_changeset(%User{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl Phoenix.LiveComponent
  # %{"space" => _space_form_params}
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :new, params) do
    case Accounts.register_user(params) do
      {:ok, user} ->
        # send email to user to confirm account
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(socket, :edit, &1)
          )

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset |> Map.put(:action, :insert))}
    end
  end
end
