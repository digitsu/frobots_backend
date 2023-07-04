alias Frobots.{Assets, Api}

xframes = [
  %{type: :Chassis_Mk1,
    weapon_hardpoints: 1,
    sensor_hardpoints: 1,
    cpu_hardpoints: 1,
    max_health: 100,
    turn_speed: 50,
    max_speed_ms: 30,
    accel_speed_mss: 5,
    movement_type: :bipedal,
    max_throttle: 100,
    class: :xframe,
    image: Api.get_s3_base_url() <> "images/equipment/chassis_mk1.png"},

    %{type: :Chassis_Mk2,
    weapon_hardpoints: 2,
    sensor_hardpoints: 1,
    cpu_hardpoints: 1,
    max_health: 120,
    turn_speed: 40,
    max_speed_ms: 30,
    accel_speed_mss: 4,
    movement_type: :bipedal,
    max_throttle: 100,
    class: :xframe,
    image: Api.get_s3_base_url() <> "images/equipment/chassis_mk2.png"},

    %{type: :Chassis_Mk3,
    weapon_hardpoints: 1,
    sensor_hardpoints: 2,
    cpu_hardpoints: 1,
    max_health: 80,
    turn_speed: 65,
    max_speed_ms: 40,
    accel_speed_mss: 7,
    movement_type: :bipedal,
    max_throttle: 100,
    class: :xframe,
    image: Api.get_s3_base_url() <> "images/equipment/chassis_mk3.png"}
]

for xframe <- xframes do
  case Assets.get_xframe(xframe.type) do
    nil -> Assets.create_xframe!(xframe)
    old_xframe -> Assets.update_xframe(old_xframe, xframe)
  end
end

cannons = [
  %{type: :Mk1,
    reload_time: 5,
    rate_of_fire: 1,
    magazine_size: 2,
    class: :cannon,
    image: Api.get_s3_base_url() <> "images/equipment/cannon_mk1.png"},

  %{type: :Mk2,
    reload_time: 10,
    rate_of_fire: 2,
    magazine_size: 4,
    class: :cannon,
    image: Api.get_s3_base_url() <> "images/equipment/cannon_mk2.png"},

  %{type: :Mk3,
    reload_time: 15,
    rate_of_fire: 3,
    magazine_size: 9,
    class: :cannon,
    image: Api.get_s3_base_url() <> "images/equipment/cannon_mk3.png"}
]

for cannon <- cannons do
  case Assets.get_cannon(cannon.type) do
    nil -> Assets.create_cannon!(cannon)
    old_cannon -> Assets.update_cannon(old_cannon, cannon)
  end
end

missiles = [
  %{
    type: :Mk1,
    damage_direct: [5,10],
    damage_near: [20,5],
    damage_far: [40,3],
    speed: 400,
    range: 900,
    class: :missile,
    image: Api.get_s3_base_url() <> "images/equipment/missile_mk1.png"
  },
  %{
    type: :Mk2,
    damage_direct: [5,20],
    damage_near: [20,10],
    damage_far: [40,6],
    speed: 400,
    range: 300,
    class: :missile,
    image: Api.get_s3_base_url() <> "images/equipment/missile_mk2.png"
  }
]

for missile <- missiles do
  case Assets.get_missile(missile.type) do
    nil -> Assets.create_missile!(missile)
    old_missile -> Assets.update_missile(old_missile, missile)
  end
end

scanners = [
  %{type: :Mk1,
    max_range: 700,
    resolution: 10,
    special: :active,
    class: :scanner,
    image: Api.get_s3_base_url() <> "images/equipment/scanner_mk1.png"},
  %{type: :Mk2,
    max_range: 300,
    resolution: 15,
    special: :passive,
    class: :scanner,
    image: Api.get_s3_base_url() <> "images/equipment/scanner_mk2.png"},
  %{type: :Mk3,
    max_range: 500,
    resolution: 12,
    special: :passive,
    class: :scanner,
    image: Api.get_s3_base_url() <> "images/equipment/scanner_mk3.png"}
]

for scanner <- scanners do
  case Assets.get_scanner(scanner.type) do
    nil -> Assets.create_scanner!(scanner)
    old_scanner -> Assets.update_scanner(old_scanner, scanner)
  end
end
