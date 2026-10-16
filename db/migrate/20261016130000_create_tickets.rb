class CreateTickets < ActiveRecord::Migration[8.1]
  def change
    create_table :tickets do |t|
      t.string :requester_name, null: false
      t.string :requester_email, null: false
      t.string :subject, null: false
      t.text :description, null: false
      t.string :status, null: false, default: "new"
      t.string :priority, null: false, default: "normal"
      t.string :assignee
      t.datetime :first_response_at
      t.datetime :solved_at
      t.datetime :response_due_at, null: false

      t.timestamps
    end

    add_index :tickets, :status
    add_index :tickets, :response_due_at
  end
end
