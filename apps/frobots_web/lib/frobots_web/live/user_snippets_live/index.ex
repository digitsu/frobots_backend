defmodule FrobotsWeb.UserSnippetsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  require Logger

  alias Frobots.Assets
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    FrobotsWeb.Presence.track(socket)
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:user_snippets, Assets.list_snippet(current_user.id))}
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
  def handle_event("react.fetch_user_snippets", _params, socket) do
    current_user = socket.assigns.current_user

    current_user = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_user_snippets", %{
       "currentUser" => current_user,
       "userSnippets" => socket.assigns.user_snippets
     })}
  end

  def handle_event("react.create_snippet", params, socket) do
    current_user = socket.assigns.current_user

    if Map.has_key?(params, "name") && Map.has_key?(params, "code") do
      snippet_data = %{
        "user_id" => current_user.id,
        "name" => Map.get(params, "name"),
        "code" => Map.get(params, "code")
      }

      case Assets.create_snippet(snippet_data) do
        {:ok, _snippet} ->
          user_snippets = Assets.list_snippet(current_user.id)

          current_user = %{
            "id" => current_user.id,
            "avatar" => current_user.avatar,
            "email" => current_user.email,
            "name" => current_user.name,
            "sparks" => current_user.sparks
          }

          {:noreply,
           push_event(
             socket
             |> assign(:user_snippets, user_snippets)
             |> put_flash(:info, "Snippet added successfully"),
             "react.return_user_snippets",
             %{
               "currentUser" => current_user,
               "userSnippets" => user_snippets
             }
           )}

        {:error, error} ->
          {:noreply,
           socket
           |> assign(:errors, error)
           |> put_flash(:error, "Could not create snippet. #{error}")}
      end
    else
      {:noreply,
       socket
       |> put_flash(:error, "Snippet name and code are required")}
    end
  end

  def handle_event("react.update_snippet", params, socket) do
    current_user = socket.assigns.current_user

    if Map.has_key?(params, "id") do
      snippet = Assets.get_snippet!(params["id"])

      case Assets.update_snippet(snippet, params) do
        :ok ->
          user_snippets = Assets.list_snippet(current_user.id)

          current_user = %{
            "id" => current_user.id,
            "avatar" => current_user.avatar,
            "email" => current_user.email,
            "name" => current_user.name,
            "sparks" => current_user.sparks
          }

          {:noreply,
           push_event(
             socket
             |> assign(:user_snippets, user_snippets)
             |> put_flash(:info, "Snippet updated successfully"),
             "react.return_user_snippets",
             %{
               "currentUser" => current_user,
               "userSnippets" => user_snippets
             }
           )}

        {:error, changeset} ->
          {:noreply,
           socket
           |> assign(:error_messages, changeset.errors)}
      end
    else
      {:noreply,
       socket
       |> put_flash(:error, "Snippet id is required")}
    end
  end

  def handle_event("react.delete_snippet", params, socket) do
    current_user = socket.assigns.current_user

    if Map.has_key?(params, "id") do
      Assets.delete_snippet(params["id"])
      user_snippets = Assets.list_snippet(current_user.id)

      current_user = %{
        "id" => current_user.id,
        "avatar" => current_user.avatar,
        "email" => current_user.email,
        "name" => current_user.name,
        "sparks" => current_user.sparks
      }

      {:noreply,
       push_event(
         socket
         |> assign(:user_snippets, user_snippets)
         |> put_flash(:info, "Snippet remoeved successfully"),
         "react.return_user_snippets",
         %{
           "currentUser" => current_user,
           "userSnippets" => user_snippets
         }
       )}
    else
      {:noreply,
       socket
       |> put_flash(:error, "Snippet id is required")}
    end
  end
end
