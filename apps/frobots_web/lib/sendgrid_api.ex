defmodule FrobotsWeb.SendgridApi do
  require HTTPoison

  @spec get_contacts(binary) :: {:error, {:status, integer} | HTTPoison.Error.t()} | {:ok, list}
  def get_contacts(base_url) do
    api_key = Application.get_env(:sendgrid, :sendgrid_mailinglist_key)
    headers = [Authorization: "Bearer #{api_key}", Accept: "Application/json"]

    HTTPoison.get(base_url <> "/v3/marketing/contacts", headers, [])
    |> process_response()
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    parsed_body = body |> Jason.decode!()
    emails = parsed_body["result"] |> Enum.map(fn x -> x["email"] end)
    {:ok, emails}
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, {:status, status_code}}
  end

  defp process_response({:error, reason}) do
    {:error, reason}
  end
end
