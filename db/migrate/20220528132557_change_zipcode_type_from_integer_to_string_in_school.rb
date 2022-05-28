class ChangeZipcodeTypeFromIntegerToStringInSchool < ActiveRecord::Migration[7.0]
  def change
    change_column :schools, :zipcode, :string
  end
end
