alias Frobots.Assets
alias Frobots.Repo

frobots = Assets.list_frobots()

for xframe <- Assets.list_xframes() |> Enum.reject(fn xf -> xf.type == :Chassis_Mk1 end) do
  for frobot <- frobots do
    %Frobots.Assets.XframeInst{}
    |> Frobots.Assets.XframeInst.changeset(%{
      max_speed_ms: xframe.max_speed_ms,
      turn_speed: xframe.turn_speed,
      max_health: xframe.max_health,
      max_throttle: xframe.max_throttle,
      accel_speed_mss: xframe.accel_speed_mss,
      user_id: frobot.user_id,
      xframe_id: xframe.id
    })
    |> Repo.insert!()
  end
end

for cannon <- Assets.list_cannons() |> Enum.reject(fn cn -> cn.type == :Mk1 end) do
  for frobot <- frobots do
    %Frobots.Assets.CannonInst{}
    |> Frobots.Assets.CannonInst.changeset(%{
      reload_time: cannon.reload_time,
      rate_of_fire: cannon.rate_of_fire,
      magazine_size: cannon.magazine_size,
      user_id: frobot.user_id,
      cannon_id: cannon.id
    })
    |> Repo.insert!()
  end
end

for scanner <- Assets.list_scanners() |> Enum.reject(fn sn -> sn.type == :Mk1 end) do
  for frobot <- frobots do
    %Frobots.Assets.ScannerInst{}
    |> Frobots.Assets.ScannerInst.changeset(%{
      max_range: scanner.max_range,
      resolution: scanner.resolution,
      user_id: frobot.user_id,
      scanner_id: scanner.id
    })
    |> Repo.insert!()
  end
end

for missile <- Assets.list_missiles() |> Enum.reject(fn mis -> mis.type == :Mk1 end) do
  for frobot <- frobots do
    %Frobots.Assets.MissileInst{}
    |> Frobots.Assets.MissileInst.changeset(%{
      damage_direct: missile.damage_direct,
      damage_near: missile.damage_near,
      damage_far: missile.damage_far,
      speed: missile.speed,
      range: missile.range,
      user_id: frobot.user_id,
      missile_id: missile.id
    })
    |> Repo.insert!()
  end
end
