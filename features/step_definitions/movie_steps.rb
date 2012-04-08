# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    title        = movie[:title]
    rating       = movie[:rating]
    release_date = movie[:release_date]
    Movie.create!(title: title, rating: rating, release_date: release_date)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  regexp = /#{e1}.*#{e2}.*/m
  assert_match page.source, regexp
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  splitted_ratings(rating_list).each do |rating|
    if uncheck
      step(%{I uncheck "filters_ratings_#{rating}"})
    else
      step(%{I check "filters_ratings_#{rating}"})
    end
  end
end

When /^I sort the movies alphabetically$/ do
  click_link "title_header"
end

When /^I sort the movies in increasing order of release date$/ do
  click_link "release_date_header"
end

Then /^I should see movies with ratings: (.*)$/ do |rating_list|
  ratings = splitted_ratings(rating_list)
  movies = Movie.filter_on_ratings(ratings)
  within("#movies") do
    movies.map(&:title).each do |title|
      assert page.has_content?(title)
    end
  end
end

Then /^I should see all of the movies$/ do
  page.has_css?("#movies tr", count: Movie.scoped.size)
end

Given /^I check none of the ratings$/ do
  Movie::ALL_RATINGS.each do |r|
    uncheck_rating(r)
  end
end

Given /^I check all of the ratings$/ do
  Movie::ALL_RATINGS.each do |r|
    check_rating(r)
  end
end

Then /^I should not see movies with ratings: (.*)$/ do |rating_list|
  ratings = splitted_ratings(rating_list)
end

def splitted_ratings(ratings)
  ratings.split(",").map(&:strip)
end

def uncheck_rating(rating)
  step(%{I uncheck "filters_ratings_#{rating}"})
end

def check_rating(rating)
  step(%{I check "filters_ratings_#{rating}"})
end