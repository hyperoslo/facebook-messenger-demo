class Product < ApplicationRecord
  enum category: [ :clothing, :footwear, :accessories ]
end
