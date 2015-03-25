class Meeting
  include Mongoid::Document
  include Mongoid::Timestamps
  include Wisper.model

  field :title, default: 'My Meeting'
  field :location

  validates :title, presence: true
end
