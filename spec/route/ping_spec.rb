describe Jinaki::Route::Ping do
  context 'with /ping' do
    let(:path) { '/ping' }

    [
      [:get, :get, 200],
      [:post, nil, 404],
      [:put, nil, 404],
      [:patch, nil, 404],
      [:delete, nil, 404]
    ].each do |method, action, status|
      context "when #{method}" do
        subject { send(method, path) }

        before { allow_any_instance_of(Jinaki::Controller::Ping).to receive(action) if action } # rubocop:disable RSpec/AnyInstance

        it "##{action} is called", if: action do
          expect_any_instance_of(Jinaki::Controller::Ping).to receive(action).once # rubocop:disable RSpec/AnyInstance
          subject
        end

        it "status #{status}" do
          expect(subject.status).to eq(status)
        end
      end
    end
  end
end
