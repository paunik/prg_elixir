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
        parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
        case parse do
            { [help: true], _, _}
                -> :help
            { _, [user, project, count], _}
                -> {user, project, String.to_integer(count)}
            { _, [user, project], _}
                -> {user, project, @default_count}
            _ -> :help
        end
    end
end