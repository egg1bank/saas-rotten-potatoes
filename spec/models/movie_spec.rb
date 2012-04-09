require 'spec_helper'

describe Movie do
  describe "#similar" do

    let(:subject){
      Movie.new( director: "Ridley Scott", title: "Aliens", release_date: "1986" )
    }

    it "finds similar movies with the received params" do
      Movie.should_receive(:similar).with({ director: "Ridley Scott" })
      subject.similar
    end
  end
end