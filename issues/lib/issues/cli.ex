defmodule Issues.CLI do
  import Issues.TableFormatter, only: [ print_table_for_issues: 2 ]
  @default_count 4

  @moduledoc """
  command line parsing
  """
  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean],
                              aliases: [h:    :help   ])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count])
  when is_binary(count),
    do: {user, project, String.to_integer(count)}

  def args_to_internal_representation([user, project, count]),
    do: {user, project, count}

  def args_to_internal_representation([user, project]),
    do: {user, project, @default_count}

  def args_to_internal_representation(_), do: :help

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [count | #{@default_count}]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_issues(["created_at", "title"])
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    IO.puts "Error fetching from github #{error["message"]}"
    System.halt(2)
  end

end
