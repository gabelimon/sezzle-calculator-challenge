class CreateCalculations < ActiveRecord::Migration[6.1]
  def change
    create_table :calculations do |t|
      t.string :formula
      t.float :result
      t.belongs_to :user, class_name: 'User', dependent: :destroy, foreign_key: true

      t.timestamps
    end
  end
end
