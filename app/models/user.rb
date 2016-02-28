class User
  include ActiveModel::Model

  attr_accessor :id, :email, :password, :first_name, :last_name
end
