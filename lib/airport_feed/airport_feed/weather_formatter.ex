defmodule AirportFeed.WeatherFormatter do
  def pretty_print(weather_data) do
    weather_data
    |> Map.keys
    |> Enum.map(&(Atom.to_string(&1)))
    |> prettify_keys
    |> get_max_width
    |> print_with_width(weather_data)
  end
  
  def get_max_width(list), do: Enum.map(list, &(String.length(&1))) |> Enum.max
  
  def print_with_width(length, data) do
    for key <- Map.keys(data) do
      key
      |> Atom.to_string
      |> prettify_string
      |> String.pad_leading(length)
      |> Kernel.<>(": #{data[key]}")
      |> IO.puts
    end
  end
 
  def prettify_keys([]), do: []
  def prettify_keys([head | tail]), do: [prettify_string(head) | prettify_keys(tail)]
  
  def prettify_string("observation_time_rfc822"), do: "Last Updated"
  def prettify_string("station_id"), do: "Station"
  def prettify_string("temperature_string"), do: "Temperature"
  def prettify_string("wind_string"), do: "Wind"
  def prettify_string(s) do
    s
    |> String.replace("_", " ")
    |> String.split
    |> Enum.map(&(String.capitalize(&1)))
    |> Enum.join(" ")
  end
end