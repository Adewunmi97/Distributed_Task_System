class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :event_type, null: false, limit: 100
      t.jsonb :payload, null: false, default: {}
      t.references :task, null: true, foreign_key: { on_delete: :cascade }, index: true
      t.datetime :processed_at, null: true

      t.timestamps null: false
    end

    # Indexes
    add_index :events, :event_type, name: 'index_events_on_event_type'
    add_index :events, :processed_at, name: 'index_events_on_processed_at'
    add_index :events, :created_at, name: 'index_events_on_created_at'
    
    # JSONB GIN index for faster JSON queries (optional but recommended)
    add_index :events, :payload, using: :gin, name: 'index_events_on_payload'
  end
end
