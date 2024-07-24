class Category < ApplicationRecord
  has_many :categorizations
  has_many :splats, through: :categorizations
end
