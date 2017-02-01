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
  end
end