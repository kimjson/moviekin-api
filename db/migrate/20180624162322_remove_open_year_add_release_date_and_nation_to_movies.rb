class RemoveOpenYearAddReleaseDateAndNationToMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :open_year, :integer
    add_column :movies, :release_date, :date
    add_column :movies, :nation, :string
  end
end
