defmodule FrobotsWeb.ArenaCreateMatchLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Assets
  alias Frobots.Accounts
  alias Frobots.Api
  alias Frobots.Events

  @impl Phoenix.LiveView
  def mount(_params, %{"user_id" => id}, socket) do
    current_user = Accounts.get_user!(id)
    s3_base_url = Api.get_s3_base_url()

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:s3_base_url, s3_base_url)
     |> assign(
       :current_user_ranking_details,
       Events.get_current_user_ranking_details(current_user)
     )}
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp extract_frobot_details(frobots) do
    Enum.map(frobots, fn %{
                           id: id,
                           name: name,
                           xp: xp,
                           class: class,
                           brain_code: brain_code,
                           blockly_code: blockly_code,
                           bio: bio,
                           avatar: avatar
                         } ->
      %{
        id: id,
        name: name,
        xp: xp,
        class: class,
        brain_code: brain_code,
        blockly_code: blockly_code,
        bio: bio,
        avatar: avatar
      }
    end)
  end

  @impl true
  def handle_event("react.fetch_create_match_details", _params, socket) do
    templateFrobots = extract_frobot_details(Assets.list_template_frobots())

    userFrobots =
      extract_frobot_details(Assets.get_available_user_frobots(socket.assigns.current_user.id))

    arenas = Api.list_arena()

    {:noreply,
     push_event(socket, "react.return_create_match_details", %{
       "s3_base_url" => socket.assigns.s3_base_url,
       "templates" => templateFrobots,
       "userFrobots" => userFrobots,
       "arenas" => arenas
     })}
  end

  @impl Phoenix.LiveView
  def handle_event("react.create_match", %{"match" => match_details}, socket) do
    match_details =
      match_details
      |> Map.put_new("user_id", socket.assigns.current_user.id)

    case Api.create_match(match_details) do
      {:ok, match} ->
        {:noreply,
         push_redirect(socket, to: Routes.arena_lobby_index_path(socket, :index, match.id))}

      {:error, errors} ->
        {:noreply, socket |> put_flash(:error, errors)}
    end
  end
end
