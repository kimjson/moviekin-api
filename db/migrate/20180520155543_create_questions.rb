# frozen_string_literal: true

# create questions table with some fields.
class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title, default: ''
      t.text :content, default: ''

      t.timestamps
    end
  end
end
