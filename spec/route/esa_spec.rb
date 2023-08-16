describe Jinaki::Route::Esa do
  context 'with /esa/events' do
    let(:path) { '/esa/events' }

    [
      [:get, nil, 404],
      [:post, :post_events, 204],
      [:put, nil, 404],
      [:patch, nil, 404],
      [:delete, nil, 404]
    ].each do |method, action, status|
      context "when #{method}" do
        subject { send(method, path) }

        before { allow_any_instance_of(Jinaki::Controller::Esa).to receive(action) if action } # rubocop:disable RSpec/AnyInstance

        it "##{action} is called", if: action do
          expect_any_instance_of(Jinaki::Controller::Esa).to receive(action).once # rubocop:disable RSpec/AnyInstance
          subject
        end

        it "status #{status}" do
          expect(subject.status).to eq(status)
        end
      end
    end
  end
end
