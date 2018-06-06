# frozen_string_literal: true

# create answers table with some fields.
class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.text :content, default: ''
      t.integer :question_id

      t.timestamps
    end
    add_index :answers, :question_id
  end
end
