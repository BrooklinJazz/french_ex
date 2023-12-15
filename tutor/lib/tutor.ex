defmodule Tutor do
  @moduledoc """
  Documentation for `Tutor`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Tutor.hello()
      :world

  """
  @tenses File.read!("verbs.json") |> Jason.decode!()

  def quiz do
    {tense, conjugations} = Enum.random(@tenses)

    {french, english} = Enum.random(conjugations)

    prompt =
      Enum.random([
        fn -> translate_to_english(english, french, tense) end,
        fn -> translate_to_french(english, french, tense) end,
        # fn -> what_tense_is_this(english, french, tense) end
      ])

    prompt.()
    quiz()
  end

  def translate_to_english(english, french, tense) do
    answer = IO.gets("translate \"#{french}\" to english\n") |> String.trim()

    case answer do
      "h" ->
        IO.puts(tense)
        translate_to_english(english, french, tense)

      _ ->
        IO.puts("It is #{english}")
    end
  end

  def translate_to_french(english, french, tense) do
    answer = IO.gets("translate \"#{english}\" to french\n") |> String.trim()

    case answer do
      "h" ->
        IO.puts(tense)
        translate_to_french(english, french, tense)

      _ ->
        IO.puts("It is #{french}")
    end
  end

  def what_tense_is_this(_english, french, tense) do
    answer = IO.gets("what tense is \"#{french}\"?\n") |> String.trim()

    case answer do
      "h" ->
        IO.puts(french)
        what_tense_is_this(_english, french, tense)

      _ ->
        IO.puts("It is #{tense}")
    end
  end
end
