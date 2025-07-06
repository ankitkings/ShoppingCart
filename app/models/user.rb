class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :mobile, format: { with: /\A\+\d{10,15}\z/, message: "must be a valid international number (e.g. +919876543210)" }

  validates :first_name, :last_name, :email, presence: true
  
  has_one :cart
  has_many :orders

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    role == 'admin'
  end

end
