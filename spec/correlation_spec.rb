require 'correlation'
require 'thread'

describe Correlation do
  it "should not allow explicit setting of the correlation_id" do
    expect { Correlation.correlation_id = "foo" }.to raise_error
  end

  describe "with_correlation_id" do
    it "should set different correlation_ids per thread" do
      queue = Queue.new

      threads = 2.times.map do
        Thread.new do
          Correlation.with_correlation_id do |correlation_id|
            queue << correlation_id
          end
        end
      end
      threads.each(&:join)

      expect(queue.length).to eq(2)

      first_id = queue.pop
      last_id = queue.pop

      expect(first_id).to_not be_nil
      expect(last_id).to_not be_nil

      expect(first_id).to_not eq(last_id)
    end

    it "should set the same correlation_id within nested calls" do
      queue = Queue.new

      Correlation.with_correlation_id do |outer_id|
        queue << outer_id
        Correlation.with_correlation_id do |inner_id|
          queue << inner_id
        end
      end

      expect(queue.length).to eq(2)

      first_id = queue.pop
      last_id = queue.pop

      expect(first_id).to eq(last_id)
      expect(first_id).to_not be_nil
    end

    it "should raise an error when trying to set the correlation_id in a nested block" do
      Correlation.with_correlation_id do
        expect { Correlation.with_correlation_id("foo") {} }.to raise_error
      end
    end

    context "when no correlation_id is passed" do
      it "should set the Correlation.correlation_id within the block" do
        Correlation.with_correlation_id do |id|
          expect(id).to_not be_nil
        end
      end

      it "should cleanup the correlation_id at the end of the block" do
        expect { Correlation.with_correlation_id {} }.to_not change { Correlation.correlation_id }.from(nil)
      end
    end

    context "when the correlation_id is passed in" do
      it "the block param should be the same as what was passed in" do
        Correlation.with_correlation_id("foo") do |id|
          expect(id).to eq("foo")
        end
      end

      it "should set the Correlation.correlation_id to be the same as the id passed in within the block" do
        Correlation.with_correlation_id("foo") do |id|
          expect(id).to eq("foo")
        end
      end

      it "should cleanup the correlation_id at the end of the block" do
        expect { Correlation.with_correlation_id {} }.to_not change { Correlation.correlation_id }.from(nil)
      end
    end
  end
end
