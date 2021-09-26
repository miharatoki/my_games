class Notification < ApplicationRecord
  belongs_to :post_comment, optional: true
  belongs_to :favorite,     optional: true
  belongs_to :sender,   class_name: 'User', foreign_key: 'sender_id',   optional: true
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', optional: true

end
