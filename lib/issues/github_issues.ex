defmodule Issues.GithubIssues do
    @user_agent [ {"User-agent", "Elixir nikola@applycolo.rs"} ]

    def fetch(user, project) do
        issues_url(user, project)
        |> HTTPoison.get(@user_agent)
        |> handle_response
    end

    def issues_url(user, project) do
        "https://api.github.com/repos/#{user}/#{project}/issues"
    end

    def handle_response({:ok, %{status_code: status_code, body: body}}) do
        {
            status_code |> check_for_error(),
            body        |> Poison.Parser.parse!()
        }
    end

    def handle_response({_, %{status_code: _, body: body}}) do
        {:error, body}
    end

    defp check_for_error(200), do: :ok
    defp check_for_error(_), do: :error

end