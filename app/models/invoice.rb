class Invoice < ApplicationRecord 
  belongs_to :merchant
  belongs_to :customer
  has_many :transactions
end