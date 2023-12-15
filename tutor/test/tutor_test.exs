defmodule TutorTest do
  use ExUnit.Case
  doctest Tutor

  test "get_verbs_json/1 _ all verbs in verbs.json" do
    Tutor.get_verbs_json() |> Enum.each(fn {french_verb, english_verb} ->
      assert french_verb != nil
      assert english_verb != nil
      assert Tutor.get_verb_tenses(french_verb) != nil
    end)
  end
end
