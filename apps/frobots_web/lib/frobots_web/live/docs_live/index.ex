defmodule FrobotsWeb.DocsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view
  @priv_dir :code.priv_dir(:frobots_web)

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    file_name = params["slug"] || "getting_started"

    file_path = Path.join([@priv_dir, "static/docs/#{file_name}.md"])

    case File.read(file_path) do
      {:ok, body} ->
        {:ok,
         socket
         |> assign(:page_title, "Docs")
         |> assign(:page_sub_title, " · Frobots Programming Guide")
         |> assign(:slug, file_name)
         |> assign(:document, body)}

      {:error, message} ->
        {:ok,
         socket
         |> put_flash(:error, "Document not found filepath : #{file_path} , error : #{message}")
         |> push_redirect(to: "/home")}
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

  @impl Phoenix.LiveView
  def handle_event("react.get_document", _params, socket) do
    {:noreply,
     push_event(socket, "react.return_document", %{
       "article" => socket.assigns.document,
       "slug" => socket.assigns.slug
     })}
  end
end
