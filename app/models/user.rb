class User < ApplicationRecord
  has_secure_password
  has_many :favourites, dependent: :destroy
  validates :email, :presence => true, :uniqueness => true
  validates_presence_of :name, :password_digest
end
