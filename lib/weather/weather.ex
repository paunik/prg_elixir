defmodule Issues.Weather do
    require Logger
    @user_agent [ {"User-agent", "Elixir nikola@applycolo.rs"} ]
    @weather_url Application.get_env(:weather, :weather_url)

    def fetch(location) do
        issues_url(location)
        |> HTTPoison.get(@user_agent)
        |> handle_response
    end

    def issues_url(location) do
        "#{@weather_url}/#{location}.xml"
    end

    def handle_response({:ok, %{status_code: status_code, body: body}}) do
        {
            status_code |> check_for_error(),
            # body |> :binary.bin_to_list |> :xmerl_scan.string |> unwrap
            body
        }
    end

    def unwrap({body, _}) do
        body
    end

    def handle_response({_, %{status_code: _, body: body}}) do
        {:error, body}
    end

    defp check_for_error(200), do: :ok
    defp check_for_error(_), do: :error

end