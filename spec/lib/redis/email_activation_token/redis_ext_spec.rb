require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

describe "redis" do
  before :all do
    @redis = Redis.new db: 15
  end

  before :each do
    @redis.flushdb
  end

  after :all do
    @redis.flushdb
    @redis.quit
  end

  describe Redis::EmailActivationToken do
    let(:email) { Faker::Internet.free_email }
    let(:obj) { described_class.new(redis: @redis) }


    describe "#generate" do
      context "Success" do
        it "Return Activation Token" do
          expect(obj.generate email).to be_kind_of String
        end
      end

      context "Set expire time" do
        it "Could set expiry" do
          token = obj.generate(email, expire: 2)
          sleep 3
          expect(@redis.exists token).to be_falsy
        end
      end
    end

    describe "#get" do
      let(:token) { obj.generate email }
      subject { obj.get token }

      it "Return token infomation hash" do
        expect(subject[:token]).to eq token
        expect(subject[:email]).to eq email
        expect(subject[:created_at]).to be_kind_of Time
      end
    end

    describe "#get_email" do
      let(:token) { obj.generate email }

      it "Token is can get email" do
        expect(obj.get_email token).to eq email
      end
    end

    describe "#get_created_at" do
      let(:token) { obj.generate email }

      it "Token is can get created_at" do
        expect(obj.get_created_at token).to be_kind_of Time
      end
    end

  end
end
