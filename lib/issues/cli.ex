defmodule Issues.CLI do
    @default_count 4
    @moduledoc """
    Handle parsing of CLI and dispatch further 
    to create table of last _n_ issues from GitHub repo 
    """
    def run(argv) do
        argv
        |> parse_args
        |> process
    end

    @doc """
    `argv` can be called by -h or --help, which returns :help
    Otherwise is github username and project name and optionally number of lines
    Returns a touple of `{user, project, count}`, or :help if help was given
    """
    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean],
                                 aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end
    def args_to_internal_representation([user, project, count]) do
        { user, project, String.to_integer(count) }
    end
    def args_to_internal_representation([user, project]) do
        { user, project, @default_count }
    end
    def args_to_internal_representation(_) do # bad arg or --help
        :help
    end
    def process(:help) do
        IO.puts """
        usage: issues <user> <project> [ count | #{@default_count} ]
        """
    end
    def process({user, project, count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response()
        |> sort_into_descending_order()
        |> last(count)
    end

    def last(list, count) do
        list
        |> Enum.take(count)
        |> Enum.reverse
    end

    def decode_response({:ok, body}), do: body 

    def decode_response({:error, error}) do
        IO.puts "Error fet=ching from GitHub: #{error["message"]}"
        System.halt(2)
    end

    def sort_into_descending_order(list_of_issues) do
        list_of_issues
        |> Enum.sort(fn i1, i2 -> 
            i1["created_at"] >= i2["created_at"]
        end)

    end
end