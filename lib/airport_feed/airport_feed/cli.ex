defmodule AirportFeed.CLI do
  @moduledoc """
  Handle command line parsing and function calls that handle printing out weather data for a given url
  """
  
  def main(argv) do
    argv
    |> parse_args
    |> process
  end
  
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    
    case parse do
      {[help: true], _} -> :help
      {_, location} -> location
      _ -> :help
    end
  end
  
  def process(:help) do
    IO.puts """
      usage: airportfeed <location>
    """
    System.halt(0)
  end
  
  def process(location) do
    AirportFeed.WeatherService.fetch(location)
    |> decode_response
  end
  
  def decode_response({:ok, response}), do: response
  def decode_response({:error, status}) do
    IO.puts "Error encountered fetching weather data: #{status}"
    System.halt(2)
  end
end