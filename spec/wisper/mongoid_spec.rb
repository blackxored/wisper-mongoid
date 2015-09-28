describe 'Mongoid' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Meeting }
  let(:id)          { "1234" }
  let(:payload) do
    { id: id }
  end

  before { Wisper::GlobalListeners.clear }

  describe '.model' do
    it 'returns Mongoid module' do
      expect(Wisper.model).to eq(Wisper::Mongoid::Publisher)
    end
  end

  describe 'when creating' do
    it 'publishes <model_name>_created event to listener' do
      expect(listener).to receive(:meeting_created).with(payload)
      model_class.subscribe(listener)
      model_class.create(id: id)
    end
  end

  describe 'when updating' do
    let(:model) { model_class.create(id: id) }

    it 'publishes <model_name>_updated event to listener' do
      expect(listener).to receive(:meeting_updated).with(payload)
      model_class.subscribe(listener)
      model.title = 'foo'
      model.save
    end
  end

  describe 'create' do
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(payload)
      model_class.subscribe(listener)
      model_class.create(id: id)
    end
  end

  describe 'update' do
    let(:model) { model_class.create(id: id) }

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(payload)
      model.subscribe(listener)
      model.update_attributes(title: 'new title')
    end
  end

  describe 'destroy' do
    let(:model) { model_class.new(id: id) }

    it 'publishes an after_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(payload)
      model_class.subscribe(listener)
      model.destroy
    end
  end

  describe '#without_broadcasting' do
    before { model_class.subscribe(listener) }
    let(:model) { model_class.new }

    it 'by does not broadcast the event' do
      expect(listener).not_to receive(:after_save)
      model.without_broadcasting { |m| m.save }
    end
  end
end
