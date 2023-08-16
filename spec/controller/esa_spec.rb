describe Jinaki::Controller::Esa do
  let(:esa_controller) { described_class.new }

  describe '#post_events' do
    subject { esa_controller.post_events(request) }

    let(:request) { JSON.parse({ body: { read: request_body } }.to_json, object_class: OpenStruct) }
    let(:request_body) { { kind: }.to_json }

    [
      ['post_create', nil],
      ['post_update', :post_update],
      ['post_archive', nil],
      ['post_delete', nil],
      ['post_start_sharing', nil],
      ['post_stop_sharing', nil],
      ['comment_create', nil],
      ['member_join', nil]
    ].each do |kind, method|
      context "when kind is '#{kind}'", if: method do
        let(:kind) { kind }

        before { allow(esa_controller).to receive(method) }

        it "##{method} is called" do
          subject
          expect(esa_controller).to have_received(method).once
        end
      end
    end
  end

  describe '#post_update' do
    subject { esa_controller.send(:post_update, params) }

    let(:post_model) { instance_double(Jinaki::Model::Post) }
    let(:slack_incoming_webhooks) { instance_double(Slack::Incoming::Webhooks) }

    before do
      allow(Jinaki::Model::Post).to receive(:new).and_return(post_model)
      allow(post_model).to receive_messages(period_exceeded?: period_exceeded, shared?: shared, wip?: wip)
      allow(post_model).to receive(:share)
      allow(post_model).to receive(:to_attachment)

      allow(Slack::Incoming::Webhooks).to receive(:new).and_return(slack_incoming_webhooks)
      allow(slack_incoming_webhooks).to receive(:post)
    end

    [
      [true, true, true, false],
      [true, true, false, false],
      [true, false, true, false],
      [true, false, false, false],
      [false, true, true, false],
      [false, true, false, false],
      [false, false, true, false],
      [false, false, false, true]
    ].each do |period_exceeded, shared, wip, result|
      context "when period_exceeded is #{period_exceeded}, shared is #{shared}, wip is #{wip}" do
        let(:params) { { post: { number: nil } } }
        let(:period_exceeded) { period_exceeded }
        let(:shared) { shared }
        let(:wip) { wip }

        it 'post will be shared', if: result do
          subject
          expect(post_model).to have_received(:share).once
        end

        it 'post will not be shared', unless: result do
          subject
          expect(post_model).not_to have_received(:share)
        end
      end
    end
  end
end
