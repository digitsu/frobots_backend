defmodule FrobotsWeb.SendgridApi do
  require HTTPoison

  @api_key System.get_env("SENDGRID_API_EXPORT_MAILINGLIST_KEY")
  @default_base_url "https://api.sendgrid.com"

  def get_contacts(base_url \\ @default_base_url, dryrun) do
    headers = [Authorization: "Bearer #{@api_key}", Accept: "Application/json"]

    HTTPoison.get(base_url <> "/v3/marketing/contacts", headers, [])
    |> process_response(dryrun)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, _dryrun) do
    parsed_body = body |> Jason.decode!()
    IO.inspect(parsed_body)

    emails = parsed_body["result"] |> Enum.map(fn x -> x["email"] end)

    {:ok, emails}
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: status_code}}, _dryrun) do
    {:error, {:status, status_code}}
  end

  defp process_response({:error, reason}, _dryrun) do
    {:error, reason}
  end
end
