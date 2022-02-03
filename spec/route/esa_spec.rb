describe Jinaki::Route::Esa do
  context '/esa/events' do
    let(:path) { '/esa/events' }

    [
      [:get, nil, 404],
      [:post, :post_events, 204],
      [:put, nil, 404],
      [:patch, nil, 404],
      [:delete, nil, 404]
    ].each do |method, action, status|
      context method do
        before { allow_any_instance_of(Jinaki::Controller::Esa).to receive(action) if action }
        subject { send(method, path) }

        it "##{action} is called", if: action do
          expect_any_instance_of(Jinaki::Controller::Esa).to receive(action).once
          subject
        end

        it "status #{status}" do
          expect(subject.status).to eq(status)
        end
      end
    end
  end
end
