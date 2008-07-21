#
# An username will be used to identify the users, instead of the email address
#
class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :username, :string, :limit => 64
    # change the existing accounts
    User.reset_column_information
    User.find(:all).each do |u|
      u.username = u.email.match(/(.*)@.*/)[1]
      u.save
    end
    # now it's possible to add a not null constraint
    change_column :users, :username, :string, :limit => 64, :null => false
  end

  def self.down
    remove_column :users, :username
  end
end
 