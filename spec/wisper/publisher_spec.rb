describe Wisper::Mongoid::Publisher do
  it 'includes Wisper::Publisher' do
    klass = Class.new do
      include Mongoid::Document
      include Mongoid::Timestamps
      include Wisper::Mongoid::Publisher
    end

    expect(klass.ancestors).to include Wisper::Publisher
  end
end
