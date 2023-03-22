alias Frobots.Assets
xframes = [
  %{xframe_type: "Tank_Mk1",
    weapon_hardpoints: 1,
    sensor_hardpoints: 1,
    cpu_hardpoints: 1,
    max_health: 100,
    turn_speed: 50,
    max_speed_ms: 30,
    accel_speed_mss: 5,
    movement_type: "tracks",
    max_throttle: 100},

    %{xframe_type: "Tank_Mk2",
    weapon_hardpoints: 2,
    sensor_hardpoints: 1,
    cpu_hardpoints: 1,
    max_health: 120,
    turn_speed: 40,
    max_speed_ms: 30,
    accel_speed_mss: 4,
    movement_type: "tracks",
    max_throttle: 100},

    %{xframe_type: "Tank_Mk3",
    weapon_hardpoints: 1,
    sensor_hardpoints: 2,
    cpu_hardpoints: 1,
    max_health: 80,
    turn_speed: 65,
    max_speed_ms: 40,
    accel_speed_mss: 7,
    movement_type: "tracks",
    max_throttle: 100},
]

for xframe <- xframes do
  case Assets.get_xframe(xframe.xframe_type) do
    nil -> Assets.create_xframe!(xframe)
    _ -> nil
  end
end

cannons = [
  %{cannon_type: "Mk1",
    reload_time: 5,
    rate_of_fire: 1,
    magazine_size: 2},

  %{cannon_type: "Mk2",
    reload_time: 7,
    rate_of_fire: 2,
    magazine_size: 3}
]

for cannon <- cannons do
  case Assets.get_cannon(cannon.cannon_type) do
    nil -> Assets.create_cannon!(cannon)
    _ -> nil
  end
end

missiles = [
  %{missile_type: "Mk1",
    damage_direct: [5,10],
    damage_near: [20,5],
    damage_far: [40,3],
    speed: 400,
    range: 900}
]

for missile <- missiles do
  case Assets.get_missile(missile.missile_type) do
    nil -> Assets.create_missile!(missile)
    _ -> nil
  end
end



scanners = [
  %{scanner_type: "Mk1",
    max_range: 700,
    resolution: 10},
  %{scanner_type: "Mk2",
    max_range: 300,
    resolution: 15},
]
for scanner <- scanners do
  case Assets.get_scanner(scanner.scanner_type) do
    nil -> Assets.create_scanner!(scanner)
    _ -> nil
  end
end
