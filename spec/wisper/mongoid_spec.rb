describe 'Mongoid' do
  let(:listener)    { double('Listener') }
  let(:model_class) { Meeting }

  before { Wisper::GlobalListeners.clear }

  describe '.model' do
    it 'returns Mongoid module' do
      expect(Wisper.model).to eq(Wisper::Mongoid::Publisher)
    end
  end

  describe 'when creating' do
    context 'and model is valid' do
      it 'publishes create_<model_name>_successful event to listener' do
        expect(listener).to receive(:create_meeting_successful).with(instance_of(model_class))
        model_class.subscribe(listener)
        model_class.create
      end
    end

    context 'and model is not valid' do
      it 'publishes create_<model_name>_failed event to listener' do
        expect(listener).to receive(:create_meeting_failed).with(instance_of(model_class))
        model_class.subscribe(listener)
        model_class.create(title: nil)
      end
    end
  end

  describe 'when updating' do
    let(:model) { model_class.create }

    context 'and model is valid' do
      it 'publishes update_<model_name>_successful event to listener' do
        expect(listener).to receive(:update_meeting_successful).with(instance_of(model_class))
        model_class.subscribe(listener)
        model.title = 'foo'
        model.save
      end
    end

    context 'and model is not valid' do
      it 'publishes update_<model_name>_failed event to listener' do
        expect(listener).to receive(:update_meeting_failed).with(instance_of(model_class))
        model_class.subscribe(listener)
        model.title = nil
        model.save
      end
    end
  end

  describe 'create' do
    it 'publishes an after_create event to listener' do
      expect(listener).to receive(:after_create).with(instance_of(model_class))
      model_class.subscribe(listener)
      model_class.create
    end
  end

  describe 'update' do
    let(:model) { model_class.create }

    it 'publishes an after_update event to listener' do
      expect(listener).to receive(:after_update).with(instance_of(model_class))
      model.subscribe(listener)
      model.update_attributes(title: 'new title')
    end
  end

  describe 'destroy' do
    let(:model) { model_class.new }

    it 'publishes an after_destroy event to listener' do
      expect(listener).to receive(:after_destroy).with(instance_of(model_class))
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
