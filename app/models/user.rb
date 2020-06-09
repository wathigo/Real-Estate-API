class User < ApplicationRecord
  has_secure_password
  has_many :favourites

  validates_presence_of :name, :email, :password_digest
end
