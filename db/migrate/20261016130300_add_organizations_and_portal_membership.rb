class AddOrganizationsAndPortalMembership < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.timestamps
    end

    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :role, :string, null: false, default: "requester"
    add_reference :users, :organization, foreign_key: true

    add_reference :tickets, :organization, foreign_key: true
    add_reference :tickets, :requester_user, foreign_key: { to_table: :users }
    add_reference :tickets, :assignee_user, foreign_key: { to_table: :users }

    add_reference :replies, :user, foreign_key: true
  end
end
