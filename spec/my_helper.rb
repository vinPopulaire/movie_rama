def signup
  visit new_user_registration_path
  fill_in 'Email', with: 'foo@mail.gr'
  fill_in 'Name', with: 'foo'
  fill_in 'Surname', with: 'bar'
  fill_in 'Password', with: '12341234'
  fill_in 'Password confirmation', with: '12341234'
  click_on 'Sign up'
end
