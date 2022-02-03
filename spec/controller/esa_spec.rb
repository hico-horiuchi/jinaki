describe Jinaki::Controller::Esa do
  let(:esa_controller) { described_class.new }

  context '#post_events' do
    let(:request) { JSON.parse({ body: { read: request_body } }.to_json, object_class: OpenStruct) }
    let(:request_body) { { kind: }.to_json }

    subject { esa_controller.post_events(request) }

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

        before { allow_any_instance_of(described_class).to receive(method) }

        it "##{method} is called" do
          expect_any_instance_of(described_class).to receive(method).once
          subject
        end
      end
    end
  end

  context '#post_update' do
    before do
      @post = double('Jinaki::Model::Post')
      @slack_webhook = double('Slack::Incoming::Webhooks')

      allow(Jinaki::Model::Post).to receive(:new).and_return(@post)
      allow(@post).to receive(:period_exceeded?).and_return(period_exceeded)
      allow(@post).to receive(:shared?).and_return(shared)
      allow(@post).to receive(:wip?).and_return(wip)
      allow(@post).to receive(:share)
      allow(@post).to receive(:to_attachment)

      allow(Slack::Incoming::Webhooks).to receive(:new).and_return(@slack_webhook)
      allow(@slack_webhook).to receive(:post)
    end

    subject { esa_controller.send(:post_update, params) }

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
          expect(@post).to receive(:share).once
          subject
        end

        it 'post will not be shared', unless: result do
          expect(@post).not_to receive(:share)
          subject
        end
      end
    end
  end
end
