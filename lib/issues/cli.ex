defmodule Issues.CLI do
    import Issues.TableFormatter, only: [ print_table_for_columns: 2 ]
    import SweetXml

    require Logger

    @default_count 4
    @moduledoc """
    Handle parsing of CLI and dispatch further 
    to create table of last _n_ issues from GitHub repo 
    """
    def main(argv) do
        argv
        |> parse_args
        |> process
    end

    @doc """
    `argv` can be called by -h or --help, which returns :help, or :help if help was given
    """
    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean],
                                 aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end
    def args_to_internal_representation([location]) do
        { location }
    end
    def args_to_internal_representation(_) do # bad arg or --help
        :help
    end
    def process(:help) do
        IO.puts """
        usage: process <location>
        """
    end
    def process({location}) do
        Issues.Weather.fetch(location)
        |> decode_response()
        |> print_table_for_columns([:location, :weather])
    end

    def last(list, count) do
        list
        |> Enum.take(count)
        |> Enum.reverse
    end

    def decode_response({:ok, body}) do
        [
            [
                {:location, body |> SweetXml.xpath(~x"//current_observation/location/text()")},
                {:weather, body |> SweetXml.xpath(~x"//current_observation/weather/text()")}
            ]
        ]
    end

    def decode_response({:error, error}) do
        IO.puts "Error fetching from Weather Url: #{error["message"]}"
        System.halt(2)
    end

    def sort_into_descending_order(list_of_issues) do
        list_of_issues
        |> Enum.sort(fn i1, i2 -> 
            i1["created_at"] >= i2["created_at"]
        end)

    end
end