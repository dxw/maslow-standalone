class AddTimestampsToNeeds < ActiveRecord::Migration
  def up
    add_column :needs, :created_at, :datetime
    add_column :needs, :updated_at, :datetime
  end

  def down
    remove_column :needs, :created_at
    remove_column :needs, :updated_at
  end
end
