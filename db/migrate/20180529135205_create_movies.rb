class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :code
      t.string :director
      t.integer :open_year
      t.integer :production_year

      t.timestamps
    end
  end
end
