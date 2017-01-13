require 'rails_helper'

feature 'restaurants' do
  context 'when no restaurants have been added' do
    scenario 'should display a prompt for adding a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      sign_up
      list_KFC
    end

    scenario 'diplay a list of restaurants' do
      visit '/restaurants'
      expect(page).to have_content 'KFC'
      expect(page).not_to have_content 'No restaurants yet'
    end
  end

  context 'create restaurant' do
    scenario 'user creates a restaurant' do
      sign_up
      list_KFC
      expect(page).to have_content "KFC"
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      scenario 'does not let you submit a name that is too short' do
        sign_up
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KF'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'KF'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing a restaurant' do
    before{ sign_up; list_KFC}
    scenario "user views a restaurant" do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content "Deep fried goodness"
      expect(current_path).to include "/restaurants/"
    end
  end

  context 'editing restaurants' do
    before do
      sign_up
      list_KFC
    end

    scenario "user cannot edit a restaurant they haven't created" do
      click_link 'Sign out'
      sign_up ("testy@mctestface.com")
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      expect(page).not_to have_content "Kentucky Fried Chicken"
      expect(page).to have_content "You can only edit restaurants you have added"
      expect(current_path).to eq restaurants_path
    end

    scenario "user can edit a restaurant they have created" do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      fill_in 'Description', with: 'Deep fried goodness'
      click_button 'Update Restaurant'
      click_link "Kentucky Fried Chicken"
      expect(page).to have_content "Kentucky Fried Chicken"
      expect(current_path).to include "/restaurants/"
    end
  end

  context 'deleting restaurants' do
    before { sign_up; list_KFC }

    scenario "when a user created it" do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "cannot be done when user didn't create it" do
      click_link 'Sign out'
      sign_up ("testy@mctestface.com")
      visit '/restaurants'
      click_link "Delete KFC"
      expect(page).to have_content "KFC"
      expect(page).to have_content "You can only delete restaurants you have created"
      expect(current_path).to eq restaurants_path
    end
  end
end
