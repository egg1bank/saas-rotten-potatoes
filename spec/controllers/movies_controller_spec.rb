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
      get :similar, id: "1"
    end

    it "finds the requested movie" do
      Movie.should_receive(:find)
      perform_action
    end

    context "When similar movies exist" do

      let(:movie){
        mock_model(Movie, id: 1, director: "Ridley Scott", similar: [])
      }

      it "gets similar movies" do
        movie.should_receive(:similar)
        perform_action
      end
    end

    context "When there are no similar movies" do
      it "redirects to home page" do
        perform_action
        response.should redirect_to(movies_path)
      end

      it "sets a flash message" do
        perform_action
        flash[:notice].should_not be_nil
      end
    end
  end
end