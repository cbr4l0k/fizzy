class CreateSplats < ActiveRecord::Migration[8.0]
  def change
    create_table :splats do |t|
      t.string :title
      t.text :body
      t.string :color

      t.timestamps
    end
  end
end
