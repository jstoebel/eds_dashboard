class FixWithdrawls < ActiveRecord::Migration
  def up

    rename_column :students, :withdrawals, :withdraws
  end

  def down

    rename_column :students, :withdraws, :withdrawals
  end
end
