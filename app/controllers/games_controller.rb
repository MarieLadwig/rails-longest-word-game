require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    9.times do
      @grid << ('A'..'Z').to_a.sample(1)[0]
    end
    @grid
  end

  def score
    @word = params[:word].upcase.split("")
    @grid = params[:grid].upcase.split("")
    @response = valid?(@word, @grid)
    if @response == "valid"
      @score = @word.length
    else
      @score = 0
    end
    @total = session_score(@score)
  end

  private

  def session_score(new_score)
    if session[:score].nil?
      session[:score] = 0
    else
      session[:score] += new_score
    end
  session[:score]
  end

  def generate_hash(letter_array)
    letters = {}
    letter_array.each do |letter|
      if letters[letter.to_sym].nil?
        letters[letter.to_sym] = 1
      else letters[letter.to_sym] += 1
      end
    end
    letters
  end

  def letter_comparison(word_letters, grid_letters)
    letters_avail = false
    word_letters.each do |letter, i|
      if grid_letters[letter].nil? || grid_letters[letter] < i
        letters_avail = false
        break
      else
        letters_avail = true
      end
    end
    letters_avail
  end

  def valid_statement(dictionary_result, grid_check)
    if dictionary_result['found'] == true && grid_check == true
      'valid'
    elsif dictionary_result['found'] == false && grid_check == false
      'is not an english word and not in the grid'
    elsif dictionary_result['found'] == false
      'is not an english word'
    else
      'is not in the grid'
    end
  end

  def valid?(attempt, grid)
    url = 'https://wagon-dictionary.herokuapp.com/'
    dictionary_check = open("#{url}#{attempt.join.downcase}").read
    dictionary_result = JSON.parse(dictionary_check)
    attempt = generate_hash(attempt)
    grid = generate_hash(grid)
    grid_check = letter_comparison(attempt, grid)
    valid_statement(dictionary_result, grid_check)
  end
end
