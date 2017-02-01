defmodule AirportFeed.WeatherService do
  import XML
  require Logger
  
  @service_url Application.get_env(:airport_feed, :service_url)
  @weather_attributes ~w(
    location station_id latitude longitude observation_time_rfc822 weather temperature_string temp_f relative_humidity 
    wind_string wind_dir wind_degrees
  )
  
  def fetch(location) do
    weather_url(location)
    |> HTTPoison.get
    |> handle_response
  end
  
  def weather_url(location) do
    "#{@service_url}#{location}.xml"
  end
  
  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    Logger.info "Successful response"
    
    body
    |> :binary.bin_to_list
    |> :xmerl_scan.string
    |> build_map(@weather_attributes)
  end
  
  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
  end
  
  defp build_map(document, attrs), do: _build_map(%{}, attrs, document)
  
  defp _build_map(map, [], _), do: map
  defp _build_map(map, [head | tail], document) do
    head_atom = String.to_atom(head)
    head_charlist = String.to_charlist(head)
    
    Map.put(map, head_atom, XML.get_text(document, '/current_observation/#{head_charlist}'))
    |> _build_map(tail, document)
  end
end