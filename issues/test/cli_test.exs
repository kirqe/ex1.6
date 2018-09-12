defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  test ":help returned by options parsing with -h or --help" do
    assert Issues.CLI.parse_args(["-h", "anything"]) == :help
    assert Issues.CLI.parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if 3 given" do
    assert Issues.CLI.parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "two values use default count" do
    assert Issues.CLI.parse_args(["user", "project"]) == {"user", "project", 4}
  end

  test "test sort_into_descending_order" do
    result = Issues.CLI.sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{ c b a}
  end

  defp fake_created_at_list(values) do
    for value <- values,
    do: %{"created_at" => value, "other_data"=> "xxx"}
  end
end
