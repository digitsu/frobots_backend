defmodule FrobotsWeb.DocsLive.Index do
  # use Phoenix.LiveView
  use FrobotsWeb, :live_view

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    fileName = params["slug"] || "getting_started"

    case File.read("apps/frobots_web/priv/static/docs/#{fileName}.md") do
      {:ok, body} ->
        {:ok,
         socket
         |> assign(:page_title, "Docs")
         |> assign(:page_sub_title, " · Frobots Programming Guide")
         |> assign(:slug, fileName)
         |> assign(:document, body)}

      {:error, _} ->
        {:ok,
         socket
         |> put_flash(:error, "Document not found")
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
