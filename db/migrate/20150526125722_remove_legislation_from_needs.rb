class RemoveLegislationFromNeeds < ActiveRecord::Migration
  def up
    remove_column :needs, :legislation
  end

  def down
    add_column :needs, :legislation, :string
  end
end
