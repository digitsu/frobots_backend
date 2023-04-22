defmodule FrobotsWeb.FrobotEquipmentBayLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.{Accounts, Assets, Api, Equipment, Events}

  @impl Phoenix.LiveView
  def mount(%{"id" => frobot_id} = _params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    # If frobot_id is missing in the url redirect user to garage
    if frobot_id === "" do
      {:ok,
       socket
       |> put_flash(:error, "Frobot id not specified in the url")
       |> push_redirect(to: "/garage")}
    end

    case Api.get_frobot_details(String.to_integer(frobot_id)) do
      {:ok, frobot_details} ->
        {:ok,
         socket
         |> assign(:user, current_user)
         |> assign(:frobot, frobot_details)
         |> assign(:user_frobots, Assets.list_user_frobots(current_user))
         |> assign(:equipments, Equipment.list_frobot_unattached_equipments(frobot_id))
         |> assign(:s3_base_url, Api.get_s3_base_url())
         |> assign(
           :current_user_ranking_details,
           Events.get_current_user_ranking_details(current_user)
         )}

      {:error, message} ->
        {:ok,
         socket
         |> put_flash(:error, message)
         |> push_redirect(to: "/garage/frobot?id=#{frobot_id}")}
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl true
  def handle_event("react.fetch_frobot_equipment_bay_details", _params, socket) do
    current_user = socket.assigns.user

    currentUser = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    {:noreply,
     push_event(socket, "react.return_frobot_equipment_bay_details", %{
       "frobotDetails" => socket.assigns.frobot,
       "availableEquipments" => socket.assigns.equipments,
       "currentUser" => currentUser,
       "userFrobots" => extract_frobots(socket.assigns.user_frobots),
       "s3_base_url" => socket.assigns.s3_base_url
     })}
  end

  @spec extract_frobots(any) :: list
  def extract_frobots(frobots) do
    Enum.map(
      frobots,
      fn %{
           id: id,
           name: name,
           brain_code: brain_code,
           class: class,
           xp: xp,
           blockly_code: blockly_code,
           avatar: avatar,
           bio: bio,
           pixellated_img: pixellated_img,
           user_id: user_id,
           inserted_at: inserted_at,
           updated_at: updated_at
         } ->
        %{
          id: id,
          name: name,
          brain_code: brain_code,
          class: class,
          xp: xp,
          blockly_code: blockly_code,
          avatar: avatar,
          bio: bio,
          pixellated_img: pixellated_img,
          user_id: user_id,
          inserted_at: inserted_at,
          updated_at: updated_at
        }
      end
    )
  end
end
