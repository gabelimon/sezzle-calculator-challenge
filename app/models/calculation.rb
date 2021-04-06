class Calculation < ApplicationRecord
  has_one :user, class_name: 'User', dependent: :delete, foreign_key: true
end
