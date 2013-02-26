# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
		Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
	regexp = /#{e1}.*#{e2}/m
	page.body =~ regexp
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
	ratings = rating_list.split(', ')
	ratings.each do |rating|
		if uncheck == "un"
			step %{I uncheck "ratings_#{rating}"}
		else
			step %{I check "ratings_#{rating}"}
		end
	end
end

Then /the following checkboxes should be (un)?checked: (.*)/ do |uncheck, rating_list|
	ratings = rating_list.split(", ")
	ratings.each do |rating|
		if uncheck == "un"
			step %{the "ratings_#{rating}" checkbox should not be checked}
		else
			step %{the "ratings_#{rating}" checkbox should be checked}
		end
	end
end

Then /the movies should (not )?be visible with the following ratings: (.*)/ do |shown, rating_list|
	shown = (shown == "not ") ? "not see" : "see"
	ratings = rating_list.split(", ")
	ratings.each do |rating|
		movies = Movie.find_all_by_rating("#{rating}")
		movies.each do |movie|
			step %{I should #{shown} "#{movie[:title]}"}
		end
	end
end
