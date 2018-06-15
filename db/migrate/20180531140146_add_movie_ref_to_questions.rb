# frozen_string_literal: true

# set many-one relationship betweeen question and movie
class AddMovieRefToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :movie, foreign_key: true
  end
end
