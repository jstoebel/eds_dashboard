class Banner < ApplicationRecord

  establish_connection :banner
  self.table_name = "saturn.szvedsd"

  scope :by_term, ->(term) {where :SZVEDSD_FILTER_TERM => term}

end
