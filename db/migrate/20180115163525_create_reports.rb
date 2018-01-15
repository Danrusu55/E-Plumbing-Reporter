class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.datetime :date_of_call
      t.string :caller_id
      t.string :category
      t.string :city
      t.string :zip
      t.string :screen
      t.string :post_screen
      t.string :total_duration
      t.string :disposition
      t.float :payout

      t.timestamps
    end
  end
end
