defmodule Issues.CLI do
    @default_count 4
    @moduledoc """
    Handle parsing of CLI and dispatch further 
    to create table of last _n_ issues from GitHub repo 
    """
    def run(argv) do
        parse_args(argv)
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
end