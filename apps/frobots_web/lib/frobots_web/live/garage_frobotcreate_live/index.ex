defmodule FrobotsWeb.GarageFrobotCreateLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  alias Frobots.Assets
  alias Frobots.Accounts
  alias Frobots.{Api, Equipment}

  @impl Phoenix.LiveView
  def mount(_params, %{"user_id" => id}, socket) do
    # set required data via assigns
    current_user = Accounts.get_user!(id)
    {:ok, s3_base_url} = Api.get_s3_base_url()

    # get templates data and store in socket
    chassis = Equipment.list_xframes()
    cannons = Equipment.list_cannons()
    scanners = Equipment.list_scanners()
    missiles = Equipment.list_missiles()

    frobot_starter_images = [
      %{
        avatar: "#{s3_base_url}/images/frobots/1.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-1.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/2.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-2.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/3.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-3.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/4.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-4.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/5.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-5.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/6.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-6.png"
      },
      %{
        avatar: "#{s3_base_url}/images/frobots/7.png",
        pixellated_img: "#{s3_base_url}/images/frobots/P-7.png"
      }
    ]

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> assign(:chassis, chassis)
     |> assign(:scanners, scanners)
     |> assign(:cannons, cannons)
     |> assign(:missiles, missiles)
     |> assign(:s3_base_url, s3_base_url)
     |> assign(:frobot_starter_images, frobot_starter_images)}
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
  def handle_event("react.fetch_frobot_create_details", _params, socket) do
    templates = Assets.list_template_frobots()
    frobot_starter_images = socket.assigns.frobot_starter_images

    {:noreply,
     push_event(socket, "react.return_frobot_create_details", %{
       "templates" => templates,
       "starterImages" => frobot_starter_images
     })}
  end

  def handle_event("react.create_frobot", params, socket) do
    current_user = socket.assigns.current_user

    if Map.has_key?(params, "name") && Map.has_key?(params, "brain_code") do
      name = Map.get(params, "name")
      brain_code = Map.get(params, "brain_code")
      optional_params = Map.delete(params, "name") |> Map.delete("brain_code")

      case Api.create_frobot(current_user, name, brain_code, optional_params) do
        {:ok, frobot_id} ->
          # get frobot equipment
          frobot_equipment = Equipment.list_frobot_equipment(frobot_id)

          {:noreply,
           socket
           |> assign(:frobot_equipment, frobot_equipment)
           |> push_redirect(to: "/garage/frobot?id=#{frobot_id}")}

        {:error, error} ->
          {:noreply,
           socket
           |> assign(:errors, error)
           |> put_flash(:error, "Could not create frobot. #{error}")}
      end
    else
      {:noreply,
       socket
       |> put_flash(:error, "Frobot name and prototype are required")}
    end
  end
end
