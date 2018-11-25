class CreateFavorites < ActiveRecord::Migration[5.0]
  def change
    create_table :favorites do |t|
      t.string :userID
      t.string :imageID

      t.timestamps
    end
  end
end
