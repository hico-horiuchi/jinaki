describe Jinaki::Model::Post do
  let(:post_model) { described_class.new(nil) }

  before do
    @esa_client = double('Esa::Client')

    allow(Esa::Client).to receive(:new).and_return(@esa_client)
    allow(@esa_client).to receive_message_chain(:post, :body).and_return(response_body)
  end

  context '#period_exceeded?' do
    publication_period_days = 7

    let(:response_body) { { created_at: created_at } }

    subject { post_model.period_exceeded? }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('PUBLICATION_PERIOD_DAYS').and_return(publication_period_days.to_s)
    end

    [
      [(Time.now - 60 * 60 * 24 * (publication_period_days + 1)).iso8601, true],
      [(Time.now - 60 * 60 * 24 * publication_period_days).iso8601, true],
      [(Time.now - 60 * 60 * 24 * (publication_period_days - 1)).iso8601, false]
    ].each do |created_at, result|
      context "if created_at is #{created_at}" do
        let(:created_at) { created_at }

        it "return #{result}" do
          expect(subject).to eq(result)
        end
      end
    end
  end

  context '#shared?' do
    let(:response_body) { { sharing_urls: sharing_urls } }

    subject { post_model.shared? }

    [
      [{ 'html' => '', 'slides' => '' }, true],
      [nil, false]
    ].each do |sharing_urls, result|
      context "if sharing_urls is #{sharing_urls}" do
        let(:sharing_urls) { sharing_urls }

        it "return #{result}" do
          expect(subject).to eq(result)
        end
      end
    end
  end

  context '#wip?' do
    let(:response_body) { { wip: wip } }

    subject { post_model.wip? }

    [
      [true, true],
      [false, false]
    ].each do |wip, result|
      context "if wip is #{wip}" do
        let(:wip) { wip }

        it "return #{result}" do
          expect(subject).to eq(result)
        end
      end
    end
  end
end
