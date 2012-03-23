# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
  @total_number_of_movies = movies_table.hashes.count
end

Given /all movies are displayed/ do
  step %Q{I check all ratings}
  step %Q{I press "ratings_submit"}
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert (page.body =~ /#{e1}.*#{e2}/m)
end

Then /I should see movies in this order:/ do |movies_list|
  table = movies_list.raw.flatten
  (1..table.count-1).each do |i|
    step %Q{I should see "#{table[i-1]}" before "#{table[i]}"}
  end
end

Then /I should see no movies/ do
  number_of_displayed_movies = page.all('table#movies//tbody//tr').count
  assert (number_of_displayed_movies == 0)
end

Then /I should see all of the movies/ do
  number_of_displayed_movies = page.all('table#movies//tbody//tr').count
  assert (number_of_displayed_movies == @total_number_of_movies)
end

Then /I should( not)? see these movies:/ do |negate, movies_list|
  movies_list.raw.flatten.each do |movie|
    step %Q{I should#{negate} see "#{movie}"}
  end
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  Movie.find_by_title(arg1).director.should == arg2
end



# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(%r{,\s*}).each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

When /I (un)?check all ratings/ do |uncheck|
  Movie.all_ratings.each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end
