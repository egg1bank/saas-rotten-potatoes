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
  rating_list.split(" ").each do |rating|
    When %{I uncheck "#{rating}"}
  end
end

When /^I sort the movies alphabetically$/ do
  click_link "title_header"
end

When /^I sort the movies in increasing order of release date$/ do
  click_link "release_date_header"
end