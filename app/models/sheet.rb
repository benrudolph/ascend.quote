class Sheet < ActiveRecord::Base
  attr_accessible :sheet, :title
  has_attached_file :sheet
  validates_attachment :sheet, :presence => true,
      :content_type => { :content_type => "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }
end
