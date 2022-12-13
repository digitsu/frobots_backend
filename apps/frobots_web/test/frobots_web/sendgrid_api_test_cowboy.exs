defmodule FrobotsWeb.SendgridApiTestRouter do
  use Plug.Router
  # import ExUnit.Assertions

  plug :match
  plug :dispatch
  plug :fetch_query_params

  get "/v3/marketing/contacts" do
    IO.inspect("inside /v3/marketing/contacts")
    # dryrun = true
    # test_server_url = "http://localhost:4040"

    # shape of data that comes back from sendgrid
    # remove all other fields except email for brevity
    return_data = ~s'''
     {
       "result": [
           {
             "email": "test1@mail.com"
           },
           {
             "email": "test2@mail.com"
           }
       ],
       "contact_count": 2,
       "_metadata": {
           "self": "https://api.sendgrid.com/v3/marketing/contacts"
       }
     }
    '''

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, return_data)
  end
end

defmodule FrobotsWeb.SendgridApiTestCowboy do
  use ExUnit.Case
  use Frobots.DataCase, async: true

  alias FrobotsWeb.SendgridApiTestRouter
  alias FrobotsWeb.SendInvites
  alias Frobots.Accounts
  alias Frobots.Accounts.User
  import Swoosh.TestAssertions

  setup do
    options = [
      scheme: :http,
      plug: SendgridApiTestRouter,
      options: [port: 4040]
    ]

    start_supervised!({Plug.Cowboy, options})
    :ok
  end

  test "get_contacts/1 hits GET /v3/marketing/contacts" do
    test_server_url = "http://localhost:4040"
    sendgrid_data = {:ok, ["test1@mail.com", "test2@mail.com"]}
    assert {:ok, body} = FrobotsWeb.SendgridApi.get_contacts(test_server_url)
    assert {:ok, body} == sendgrid_data
  end

  test "given user emails application sends beta invite email" do
    mail = SendInvites.build_mail("test user1", "test1@mail.com", "1234", "abcd1234")
    Swoosh.Adapters.Test.deliver(mail, [])
    assert_email_sent(mail)
  end
end
