class Splat < ApplicationRecord
  has_many :categorizations
  has_many :categories, through: :categorizations, dependent: :destroy

  enum :color, %w[ dodgerblue limegreen tomato mediumorchid ].index_by(&:itself), suffix: true, default: :dodgerblue
end
