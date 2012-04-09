require 'spec_helper'
describe MoviesController do
  describe "#similar_movies" do

    let(:movie){
      mock_model(Movie, id: 1, director: "Ridley Scott", similar: [])
    }

    before do
      Movie.stub(find: movie)
    end

    def perform_action
      get :similar
    end

    it "gets similar movies" do
      movie.should_receive(:similar)
      perform_action
    end

    it "finds the requested movie" do
      Movie.should_receive(:find)
      perform_action
    end

    it "redirects to home page if there are no similar movies" do
      perform_action
      response.should redirect_to(movies_path)
    end

    it "sets a flash message when there are no similar movies" do
      perform_action
      flash[:notice].should_not be_nil
    end
  end
end