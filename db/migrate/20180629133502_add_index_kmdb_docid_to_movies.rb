class AddIndexKmdbDocidToMovies < ActiveRecord::Migration[5.2]
  def change
    add_index :movies, :kmdb_docid, unique: true
  end
end
