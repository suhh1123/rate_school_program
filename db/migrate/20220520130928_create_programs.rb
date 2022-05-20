class CreatePrograms < ActiveRecord::Migration[7.0]
  def change
    create_table :programs do |t|
      t.string :title
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
