class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :link
      t.string :body
      t.integer :position
      t.references :folder, null: false, foreign_key: true
      t.timestamps
    end
  end
end
