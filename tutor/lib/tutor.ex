defmodule Tutor do
  @moduledoc """
  Documentation for `Tutor`.
  """

  @verbs File.read!("verbs.json") |> Jason.decode!()

  def quiz do
    verb = random_verb()

    exercise =
      Enum.random([
        &translate_french_verb/1,
        &translate_english_verb/1,
        &translate_english_conjugation/1,
        &translate_french_conjugation/1,
        &provide_the_tense/1,
        &full_quiz/1
      ])

    ask(exercise.(verb))
    quiz()
  end

  def ask([]), do: IO.puts("Quiz complete!")

  def ask([message | tail]) when is_binary(message) do
    IO.puts("""
    ========================================
    #{message}
    ========================================
    """)

    ask(tail)
  end

  def ask([%Question{} = question | tail]) do
    ask(question)
    ask(tail)
  end

  def ask(%Question{question: question, answer: answer}) do
    _response = IO.gets(question) |> String.trim() |> String.downcase()

    IO.puts("The answer is #{answer}")
  end

  def random_verb, do: Enum.random(@verbs)

  def translate_french_verb({french_verb, english_verb}) do
    %Question{question: "what is #{french_verb} in english?\n", answer: english_verb}
  end

  def translate_english_verb({french_verb, english_verb}) do
    %Question{question: "what is #{english_verb} in french?\n", answer: french_verb}
  end

  def translate_english_conjugation({french_verb, english_verb}) do
    tenses = get_verb_tenses(french_verb)
    {tense, conjugations} = Enum.random(tenses)
    {french_conjugation, english_conjugation} = Enum.random(conjugations)
    %Question{question: "what is #{english_conjugation} in french?\n", answer: french_conjugation}
  end

  def translate_french_conjugation({french_verb, english_verb}) do
    tenses = get_verb_tenses(french_verb)
    {tense, conjugations} = Enum.random(tenses)
    {french_conjugation, english_conjugation} = Enum.random(conjugations)

    %Question{
      question: "what is #{french_conjugation} in english?\n",
      answer: english_conjugation
    }
  end

  def provide_the_tense({french_verb, english_verb}) do
    tenses = get_verb_tenses(french_verb)
    {tense, conjugations} = Enum.random(tenses)
    {french_conjugation, _english_conjugation} = Enum.random(conjugations)
    %Question{question: "what tense is #{french_conjugation}", answer: tense}
  end

  def full_quiz({french_verb, english_verb} = verb) do
    tenses = get_simple_verb_tenses(french_verb)

    conjugation_questions =
      Enum.map(tenses, fn {tense, conjugation} ->
        questions =
          Enum.map(conjugation, fn {french_conjugation, english_conjugation} ->
            subject = get_subject(french_conjugation)
            %Question{question: "#{subject} ", answer: french_conjugation}
          end)

        ["fill in the conjugations for #{french_verb} in #{tense}", questions]
      end)
      |> List.flatten()

    [
      "Starting quiz on #{french_verb}",
      translate_french_verb(verb)
      | conjugation_questions
    ]
  end

  def get_simple_verb_tenses(verb) do
    tenses = get_verb_tenses(verb)

    past = Enum.find(tenses, fn {tense, _} -> tense == "Passé composé (Present Perfect)" end)
    present = Enum.find(tenses, fn {tense, _} -> tense == "Présent (Present)" end)
    future = Enum.find(tenses, fn {tense, _} -> tense == "Futur simple (Simple Future)" end)

    [present, past, future]
  end

  def get_verbs_json, do: @verbs

  def get_verb_tenses(verb) do
    File.read!(verb_file_path(verb)) |> Jason.decode!()
  end

  @doc """
  Get the subject of a french conjugation

  iex> Tutor.get_subject("je suis")
  "je"
  iex> Tutor.get_subject("j'etais")
  "j'"
  iex> Tutor.get_subject("tu es")
  "tu"
  iex> Tutor.get_subject("il/elle est")
  "il/elle"
  iex> Tutor.get_subject("nous sommes")
  "nous"
  iex> Tutor.get_subject("vous etes")
  "vous"
  iex> Tutor.get_subject("ils/elles sont")
  "ils/elles"
  """
  def get_subject(french_conjugation) do
    Regex.run(~r/je|j\'|tu|il\/elle|nous|vous|ils\/elles/i, french_conjugation) |> hd()
  end


  # se réveiller -> verbs/se_reveiller.json
  defp verb_file_path(verb) do
    file_name =
      verb
      |> String.normalize(:nfd)
      |> String.replace(~r/[^A-z\s]/u, "")
      |> String.replace(~r/\s/, "_")

    "verbs/#{file_name}.json"
  end
end
