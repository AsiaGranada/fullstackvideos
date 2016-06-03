class Video < ApplicationRecord
  enum level: [:free, :beginner, :advanced]
end
