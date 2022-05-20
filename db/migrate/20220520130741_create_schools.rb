class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :country

      t.timestamps
    end
  end
end
