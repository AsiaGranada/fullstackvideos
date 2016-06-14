class Video < ApplicationRecord
  enum level: [:free, :beginner, :advanced]
  has_many :resources
  has_many :relateds
  accepts_nested_attributes_for :relateds, allow_destroy: true
  accepts_nested_attributes_for :resources, allow_destroy: true
end
