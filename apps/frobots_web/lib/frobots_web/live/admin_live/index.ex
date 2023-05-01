defmodule FrobotsWeb.AdminLive.Index do
  use FrobotsWeb, :live_view
  require Logger
  alias Frobots.{Api, Accounts}

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])
    cond do
      Accounts.user_is_admin?(current_user) ->
        bucket = Api.get_s3_bucket_name()
        base_url = Api.get_s3_base_url()

        files = get_files(bucket, base_url)

        {:ok,
         socket
         |> assign(:current_user, current_user)
         |> assign(:uploaded_files, [])
         |> assign(:image_files, files)
         |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 2)}
      true ->
        {:error, "Not authorized"}
    end
  end

  def get_files(bucket, base_url) do
    case ExAws.S3.list_objects_v2(bucket) |> ExAws.request() do
      {:ok, response} ->
        response.body.contents
        |> Enum.map(fn x ->
          %{
            "file_name" => x.key,
            "file_path" => "#{base_url}/#{x.key}"
          }
        end)

      {:error, _error} ->
        []
    end
  end

  # add additional handle param events as needed to handle button clicks etc
  # @impl Phoenix.LiveView
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  # end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    s3_bucket = Api.get_s3_bucket_name()
    base_url = Api.get_s3_base_url()

    # uploaded_files =
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
      path
      |> ExAws.S3.Upload.stream_file()
      |> ExAws.S3.upload(s3_bucket, "images/#{entry.client_name}", acl: :public_read)
      |> ExAws.request()

      {:ok, Path.basename(path)}
    end)

    files = get_files(s3_bucket, base_url)

    {:noreply, socket |> assign(:image_files, files)}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
