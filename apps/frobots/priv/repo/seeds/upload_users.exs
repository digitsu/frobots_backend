File.read!("contacts.csv" )
|> String.split(",", trim: true)
|> Enum.filter(fn x -> String.contains?(x, "@") end)
|> Enum.map( fn x -> Regex.split(~r{\n}, x) end)
|> Enum.into( [], fn [_, email] -> email end)
|> Enum.map( list, fn x -> String.replace(x, "\"", "") end)
