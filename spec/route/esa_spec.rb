describe Jinaki::Route::Esa do
  context '/esa/events' do
    let(:path) { '/esa/events' }

    context 'post' do
      before { allow_any_instance_of(Jinaki::Endpoint::Esa).to receive(:post_events) }
      subject { post(path) }

      it 'status 204' do
        expect_any_instance_of(Jinaki::Endpoint::Esa).to receive(:post_events).once
        expect(subject.status).to eq 204
      end
    end
  end
end
