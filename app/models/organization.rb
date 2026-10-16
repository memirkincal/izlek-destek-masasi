class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tickets, dependent: :destroy

  validates :name, presence: true, length: { maximum: 100 }
end
