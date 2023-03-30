defmodule FrobotsWeb.ArenaCreateMatchLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Assets
  alias Frobots.Accounts

  @impl Phoenix.LiveView
  def mount(_params, %{"user_id" => id}, socket) do
    current_user = Accounts.get_user!(id)
    {:ok, socket |> assign(:current_user, current_user)}
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
    userFrobots = extract_frobot_details(Assets.list_user_frobots(socket.assigns.current_user))

    {:noreply,
     push_event(socket, "react.return_create_match_details", %{
       "templates" => templateFrobots,
       "userFrobots" => userFrobots
     })}
  end
end
