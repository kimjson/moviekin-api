class RenameColumnsOfMovies < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :name, :title
    rename_column :movies, :code, :kmdb_seq
  end
end
