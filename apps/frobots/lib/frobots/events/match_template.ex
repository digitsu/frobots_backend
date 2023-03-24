defmodule Frobots.Events.MatchTemplate do
  # this defines what is saved when a match is completed.
  use Ecto.Schema
  import Ecto.Changeset

  # a battlelog is written after a match is completed, and there are winners declared.
  embedded_schema do
    # per frobot in qudos to join match
    field :entry_fee, :integer
    # percent of qudos to be paid to arena
    field :commission_rate, :integer
    field :match_type, Ecto.Enum, values: [individual: "single", team: "team"]
    # list of percentage payouts, the size of the array defines how many frobots can win
    field :payout_map, {:array, :integer}
    field :max_frobots, :integer
    field :min_frobots, :integer
  end

  @doc false
  def changeset(%Frobots.Events.MatchTemplate{} = match_template, attrs) do
    match_template
    |> cast(attrs, [
      :entry_fee,
      :commission_rate,
      :match_type,
      :payout_map,
      :max_frobots,
      :min_frobots
    ])
    |> validate_required([
      :entry_fee,
      :commission_rate,
      :match_type,
      :payout_map,
      :max_frobots,
      :min_frobots
    ])
  end

  defp validate_frobots(match_data) do
    if Map.get(match_data, "frobots", nil), do: :ok, else: {:error, :missing_frobots_list}
  end

  defp validate_entry_fee(match_data) do
    if Map.get(match_data, "entry_fee", nil), do: :ok, else: {:error, :missing_entry_fee}
  end

  defp validate_commission_rate(match_data) do
    if Map.get(match_data, "commission_rate", nil),
      do: :ok,
      else: {:error, :missing_commission_rate}
  end

  defp validate_match_type(match_data) do
    if Map.get(match_data, "match_type", nil), do: :ok, else: {:error, :missing_match_type}
  end

  defp validate_payout_map(match_data) do
    if Map.get(match_data, "payout_map", nil), do: :ok, else: {:error, :missing_payout_map}
  end

  defp validate_max_frobots(match_data) do
    if Map.get(match_data, "max_frobots", nil), do: :ok, else: {:error, :missing_max_frobots}
  end

  defp validate_min_frobots(match_data) do
    if Map.get(match_data, "min_frobots", nil), do: :ok, else: {:error, :missing_min_frobots}
  end

  def validate_match_data(match_data) do
    with :ok <- validate_frobots(match_data),
         :ok <- validate_entry_fee(match_data),
         :ok <- validate_commission_rate(match_data),
         :ok <- validate_match_type(match_data),
         :ok <- validate_payout_map(match_data),
         :ok <- validate_max_frobots(match_data),
         :ok <- validate_min_frobots(match_data) do
      {:ok, match_data}
    end
  end
end
