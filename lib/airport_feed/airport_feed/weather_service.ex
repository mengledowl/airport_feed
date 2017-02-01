defmodule AirportFeed.WeatherService do
  import XML
  require Logger
  
  @service_url Application.get_env(:airport_feed, :service_url)
  
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
    |> XML.get_text('/current_observation/weather')
  end
  
  defp handle_response({_, %{status_code: status, body: body}}) do
    Logger.error "Error #{status} returned"
  end
end