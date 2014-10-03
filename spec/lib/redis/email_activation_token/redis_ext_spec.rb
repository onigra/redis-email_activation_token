require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

describe "redis" do
  before :all do
    @redis = Redis.new :db => 15
  end

  before :each do
    @redis.flushdb
  end

  after :all do
    @redis.quit
  end

  describe Redis::EmailActivationToken do
    let(:obj) { Redis::EmailActivationToken.new(Faker::Internet.free_email, redis: @redis) }

    describe "#create" do
      context "nothing" do
        subject { obj.create }

        it "Return Activation Token" do
          is_expected.to be_kind_of String
        end
      end

      context "exists" do
        before { obj.create }
        subject { obj.create }
        it { is_expected.to be_falsy }
      end
    end

    describe "#exists?" do
      context "nothing" do
        subject { obj.exists? }
        it { is_expected.to be_falsy }
      end

      context "exists" do
        before { obj.create }
        subject { obj.exists? }
        it { is_expected.to be_truthy }
      end
    end

    describe "#get" do
      context "nothing" do
        subject { obj.get }
        it { is_expected.to be_falsy }
      end

      context "exists" do
        before { obj.create }
        subject { obj.get }

        it "Return Activation Token" do
          is_expected.to be_kind_of String
        end
      end
    end

    describe "Expiry Time Set" do
      let(:obj) { Redis::EmailActivationToken.new(Faker::Internet.free_email, redis: @redis, expire: 5) }

      it "expite == 5" do
        expect(obj.expire).to eq 5
      end

      it "Expire Check" do
        obj.create
        sleep 6
        expect(obj.exists?).to be_falsy
      end
    end
  end

end
