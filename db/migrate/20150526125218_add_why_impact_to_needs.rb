class AddWhyImpactToNeeds < ActiveRecord::Migration
  def up
    add_column :needs, :why_impact, :string
  end

  def down
    remove_column :need, :why_impact
  end
end
