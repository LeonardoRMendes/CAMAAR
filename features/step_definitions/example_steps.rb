Given('I am on the homepage') do
  visit '/'
end

When('I visit the site') do

end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end
