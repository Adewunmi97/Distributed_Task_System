class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, limit: 200
      t.text :description
      t.string :state, null: false, default: 'draft', limit: 50
      
      # Foreign keys
      t.references :creator, null: false, foreign_key: { to_table: :users }, index: true
      t.references :assignee, null: true, foreign_key: { to_table: :users }, index: true

      t.timestamps null: false
    end
    # Additional indexes
    add_index :tasks, :state, name: 'index_tasks_on_state'
    
    # Composite index for common query: tasks by assignee and state
    add_index :tasks, [:assignee_id, :state], name: 'index_tasks_on_assignee_id_and_state'
  end
end
