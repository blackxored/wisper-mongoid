require 'wisper/mongoid/version'
require 'wisper/mongoid/publisher'

module Wisper
  def self.model
    ::Wisper::Mongoid::Publisher
  end

  module Mongoid
    def self.extend_all
      # TODO: Include model on all mongoid documents
      fail NotImplementedError
    end
  end
end
