defmodule Tutor do
  @moduledoc """
  Documentation for `Tutor`.
  """

  @verbs File.read!("verbs.json") |> Jason.decode!()
  @verb_conjugations File.ls!("./verbs") |> Enum.map(fn file -> "./verbs/#{file}" |> File.read!() |> Jason.decode!() end)
  # @tenses File.read!("verbs.json") |> Jason.decode!()

  def quiz do
    conjugations = Enum.random(@verb_conjugations)
    {tense, conjugation} = Enum.random(conjugations)

    {french, english} = Enum.random(conjugations)

    prompt =
      Enum.random([
        # fn -> translate_to_english(english, french, tense) end,
        # fn -> translate_to_french(english, french, tense) end,
        # fn -> what_tense_is_this(english, french, tense) end,
        fn -> what_french_verb_is_this() end,
        fn -> what_english_verb_is_this() end
      ])

    prompt.()
    quiz()
  end

  def what_french_verb_is_this do
    {french, english} = @verbs |> Enum.random()

    answer = IO.gets("what is #{french} in english?\n") |> String.trim()
    IO.puts("#{english}\n")
  end

  def what_english_verb_is_this do
    {french, english} = @verbs |> Enum.random()

    answer = IO.gets("what is #{english} in french?\n") |> String.trim()
    IO.puts("#{french}\n")
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
