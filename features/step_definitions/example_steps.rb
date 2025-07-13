Given('I am on the homepage') do
  visit '/'
end

When('I visit the site') do
  # This step is already covered by the previous step
  # You can add additional navigation logic here if needed
end

Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end
