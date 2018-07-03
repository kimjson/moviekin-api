class RenameKmdbSeqOfMoviesToKmdbDocid < ActiveRecord::Migration[5.2]
  def change
    rename_column :movies, :kmdb_seq, :kmdb_docid
  end
end
