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

    case Assets.get_frobot(String.to_integer(frobot_id)) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Not found any frobot with id #{frobot_id}")
         |> push_redirect(to: "/garage")}

      frobot ->
        if frobot.user_id !== current_user.id do
          {:ok,
           socket
           |> put_flash(:error, "You don't have access to view this frobot")
           |> push_redirect(to: "/garage")}
        else
          {:ok,
           socket
           |> assign(:frobot, frobot)
           |> assign(:user, current_user)
           |> assign(:s3_base_url, Api.get_s3_base_url())
           |> assign(:user_frobots, Assets.list_user_frobots(current_user))
           |> assign(:attached_equipments, Equipment.list_frobot_equipment_details(frobot_id))
           |> assign(
             :user_equipment_inventory,
             Equipment.list_user_equipment_details(current_user.id)
           )
           |> assign(
             :current_user_ranking_details,
             Events.get_current_user_ranking_details(current_user)
           )}
        end
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
    %{
      user: current_user,
      frobot: frobot,
      s3_base_url: s3_base_url,
      user_frobots: user_frobots,
      attached_equipments: attached_equipments,
      user_equipment_inventory: user_equipment_inventory
    } = socket.assigns

    current_user = %{
      "id" => current_user.id,
      "avatar" => current_user.avatar,
      "email" => current_user.email,
      "name" => current_user.name,
      "sparks" => current_user.sparks
    }

    frobot_details = %{
      "frobot_id" => frobot.id,
      "name" => frobot.name,
      "bio" => frobot.bio,
      "pixellated_img" => frobot.pixellated_img,
      "user_id" => frobot.user_id,
      "avatar" => frobot.avatar,
      "class" => frobot.class,
      "inserted_at" => frobot.inserted_at
    }

    equipment_inventory = _format_equipment_details(user_equipment_inventory)

    available_equipments =
      if Enum.empty?(equipment_inventory) do
        []
      else
        Enum.filter(equipment_inventory, fn equipment ->
          is_nil(equipment["frobot_id"])
        end)
      end

    frobot_equipments = _format_equipment_details(attached_equipments)

    {:noreply,
     push_event(socket, "react.return_frobot_equipment_bay_details", %{
       "currentUser" => current_user,
       "frobotDetails" => frobot_details,
       "s3_base_url" => s3_base_url,
       "userFrobots" => extract_frobots(user_frobots),
       "frobotEquipments" => frobot_equipments,
       "equipmentInventory" => available_equipments
     })}
  end

  def handle_event("react.detach_frobot_equipments", params, socket) do
    %{
      "equipment_class" => equipment_class,
      "id" => equipment_id,
      "frobot_id" => frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    case Equipment.dequip_part(equipment_id, equipment_class) do
      {:ok, _equipment_inst} ->
        get_latest_info(
          frobot_id,
          "frobot dequipped part instance",
          current_equipment_key,
          socket
        )

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def handle_event("react.detach_frobot_xframe", params, socket) do
    %{
      "frobot_id" => frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    frobot = Assets.get_frobot!(frobot_id)

    case Equipment.dequip_xframe(frobot) do
      {:ok, _xframe} ->
        get_latest_info(frobot_id, "xframe detached successfully", current_equipment_key, socket)

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def handle_event("react.frobot_equipy_equipment", params, socket) do
    %{
      "equipment_class" => equipment_class,
      "id" => equipment_id,
      "frobot_id" => frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    case Equipment.equip_part(equipment_id, frobot_id, equipment_class) do
      {:ok, message} ->
        get_latest_info(frobot_id, message, current_equipment_key, socket)

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def handle_event("react.frobot_equipy_xframe", params, socket) do
    %{
      "id" => equipment_id,
      "frobot_id" => frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    case Equipment.equip_xframe(equipment_id, frobot_id) do
      {:ok, message} ->
        get_latest_info(frobot_id, message, current_equipment_key, socket)

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def handle_event("react.frobot_redeploy_xframe", params, socket) do
    %{
      "frobot_id" => frobot_id,
      "current_frobot_id" => current_frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    frobot = Assets.get_frobot!(frobot_id)

    case Equipment.dequip_xframe(frobot) do
      {:ok, _xframe} ->
        get_latest_info(
          current_frobot_id,
          "Successfully redeployed xframe",
          current_equipment_key,
          socket
        )

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def handle_event("react.frobot_redeploy_equipment", params, socket) do
    %{
      "equipment_class" => equipment_class,
      "id" => equipment_id,
      "current_frobot_id" => current_frobot_id,
      "current_equipment_key" => current_equipment_key
    } = params

    case Equipment.dequip_part(equipment_id, equipment_class) do
      {:ok, _equipment_inst} ->
        get_latest_info(
          current_frobot_id,
          "Successfully redeployed part instance",
          current_equipment_key,
          socket
        )

      {:error, reason} ->
        {:noreply, socket |> put_flash(:error, reason)}
    end
  end

  def get_latest_info(frobot_id, message, current_equipment_key, socket) do
    %{user: current_user} = socket.assigns

    frobot = Assets.get_frobot!(frobot_id)
    user_equipment_inventory = Equipment.list_user_equipment_details(current_user.id)
    attached_equipments = Equipment.list_frobot_equipment_details(frobot_id)
    equipment_inventory = _format_equipment_details(user_equipment_inventory)

    available_equipments =
      if Enum.empty?(equipment_inventory) do
        []
      else
        Enum.filter(equipment_inventory, fn equipment ->
          is_nil(equipment["frobot_id"])
        end)
      end

    frobot_equipments = _format_equipment_details(attached_equipments)

    {:noreply,
     push_event(
       socket
       |> assign(:frobot, frobot)
       |> assign(:attached_equipments, attached_equipments)
       |> assign(:user_equipment_inventory, user_equipment_inventory)
       |> put_flash(:info, message),
       :frobot_equipments_updated,
       %{
         "frobotEquipments" => frobot_equipments,
         "equipmentInventory" => available_equipments,
         "currentEquipmentKey" => current_equipment_key
       }
     )}
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

  defp _format_equipment_details(equipments) do
    final_equipments = equipments["xframes"] ++ equipments["cannons"] ++ equipments["scanners"]

    if Enum.empty?(final_equipments) do
      []
    else
      Enum.map(final_equipments, fn equipment ->
        Map.put(
          equipment,
          "equipment_key",
          "#{equipment["id"]}-#{equipment["equipment_class"]}-#{equipment["equipment_type"]}"
        )
      end)
    end
  end
end
