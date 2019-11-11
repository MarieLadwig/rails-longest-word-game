require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector ".letter", count: 9
  end

  test "You can fill the form with a random word, click the play button, and get a message that the word is not in the grid." do
    visit new_url
    fill_in "word", with: "asdwe"
    click_on "Play!"
    assert test: "New game"
    assert_selector ".response", text: "Sorry! ASDWE is not an english word and not in the grid :( Your score is 0"
  end

  test "You can fill the form with a one-letter consonant word, click play, and get a message it’s not a valid English word" do
    visit new_url
    fill_in "word", with: "k"
    click_on "Play!"
    assert test: "New game"
    assert_selector ".response", text: 'not an english word'
  end
end
