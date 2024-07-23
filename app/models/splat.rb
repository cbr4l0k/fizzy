class Splat < ApplicationRecord
  attribute :tag, :string

  enum :color, %w[ dodgerblue limegreen tomato mediumorchid ].index_by(&:itself), suffix: true, default: :dodgerblue
  enum :tag, %w[ Product UI Web Mobile Feature Support iOS Android ].index_by(&:itself), suffix: true
end
