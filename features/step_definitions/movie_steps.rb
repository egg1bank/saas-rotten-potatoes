Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}.*/m
  assert_match page.source, regexp
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|

  splitted_ratings(rating_list).each do |rating|
    if uncheck
      uncheck_rating(rating)
    else
      check_rating(rating)
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

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie, director|
  page.has_content?(director)
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