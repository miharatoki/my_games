class Notification < ApplicationRecord
  belongs_to :post,             optional: true
  belongs_to :post_comment,     optional: true
  belongs_to :favorite,         optional: true
  belongs_to :relationship,     optional: true
  belongs_to :sender,   class_name: 'User', optional: true
  belongs_to :receiver, class_name: 'User', optional: true
end
