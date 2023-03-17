alias Frobots.Assets
alias Frobots

for {name, brain_path} <- Frobots.frobot_paths() do
  case Assets.get_frobot!(~s/#{name}/) do
    %Assets.Frobot{} = frobot -> Assets.update_frobot(frobot, %{brain_code: File.read!(brain_path) })
  end
end
