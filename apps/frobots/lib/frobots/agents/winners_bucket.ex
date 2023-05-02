defmodule Frobots.Agents.WinnersBucket do
  use Agent

  def start_link([]) do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  # search if there is a matching combo for winner
  def add_or_update_score(username, winner, participants) do
    case item_exists?(username, winner, participants) do
      nil ->
        add_item(username, winner, participants, 1, 10)

      item ->
        occurence = item["occurences"] + 1
        update_item(username, winner, participants, occurence, item["points"])
    end
  end

  #
  def item_exists?(_username, winner, participants) do
    item =
      value()
      |> Enum.filter(fn x ->
        x["frobot_id"] == winner and x["frobots"] == participants
      end)

    if Enum.empty?(item) do
      nil
    else
      hd(item)
    end
  end

  def update_item(username, winner, participants, occurences, points) do
    latest_points =
        case occurences do
          1 ->
            10
          2 ->
            points / 2
          3 ->
            points / 4
          4 -
            1
          _ ->
            0
        end

    new_state =
      value()
      |> Enum.map(fn x ->
        # x["username"] == username and
        if x["frobot_id"] == winner and x["frobots"] == participants do
          %{
            "username" => username,
            "frobot_id" => winner,
            "frobots" => participants,
            "occurences" => occurences,
            "points" => x["points"] + trunc(latest_points)
          }
        else
          x
        end
      end)

    Agent.update(__MODULE__, fn _state -> new_state end)
  end

  def load(entries) do
    Agent.update(__MODULE__, fn state -> state ++ entries end)
  end

  def reset() do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  def add_item(username, frobot_id, frobots, occurence, points) do
    data = %{
      "username" => username,
      "frobot_id" => frobot_id,
      "frobots" => frobots,
      "occurences" => occurence,
      "points" => points
    }

    Agent.update(__MODULE__, fn state -> state ++ [data] end)
  end
end
