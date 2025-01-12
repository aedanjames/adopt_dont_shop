require 'rails_helper'

RSpec.describe 'The admin shelters show page' do 
    before :each do 
        @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora', foster_program: false, rank: 9, street_address: "214 w placid", state: "CO", zipcode: "82743")
        @shelter_2 = Shelter.create(name: 'Englewood shelter', city: 'Englewood', foster_program: false, rank: 9, street_address: "7325 w Hampden", state: "CO", zipcode: "80239")
        @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 12, adoptable: true)
        @pet_3 = @shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

        @application_1 = Application.create!(name: "Sedan Turtle", street_address: "3425 Gransfield ave", city: "Denver", state: "CO", zipcode: "80219", status: "Pending")
        @application_1.pets << @pet_3
    end 
    it 'shows the shelters name and full address' do 
        visit "/admin/shelters/#{@shelter_1.id}"
        expect(page).to have_content("Admin Shelter Show Page")
        expect(page).to have_content(@shelter_1.name)
        expect(page).to have_content(@shelter_1.city)
        expect(page).to have_content(@shelter_1.street_address)
        expect(page).to have_content(@shelter_1.state)
        expect(page).to have_content(@shelter_1.zipcode)
        @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 2, adoptable: false)
        @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 8, adoptable: true)
        @pet_3 = @shelter_2.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
        @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 12, adoptable: true)
    end 

    it 'has a section for statistics where the average age of all adoptable pets for that shelter is visible' do 
        visit "/admin/shelters/#{@shelter_1.id}"
        within(".statistics") do 
            expect(page).to have_content(@shelter_1.adoptable_pets_avg_age)
        end 
    end 

    it 'has a section for statistics where the number of all adoptable pets for that shelter is visible' do 
        visit "/admin/shelters/#{@shelter_1.id}"
        within(".statistics") do 
            expect(page).to have_content(@shelter_1.adoptable_pet_count)
        end 
    end 

    it 'has an action required section where pets with pending apps for that shelter are listed' do 
        visit "/admin/shelters/#{@shelter_1.id}"
        within(".action_required") do 
            expect(page).to have_content("Action Required")
            expect(page).to have_content(@pet_3.name)
            expect(page).to have_no_content(@pet_2.name)
        end 
    end 

    it 'has an action required link that brings the user to the admin application show page where decisions are to be made' do 
        visit "/admin/shelters/#{@shelter_1.id}"
        within(".action_required") do 
            expect(page).to have_content("Action Required")
            expect(page).to have_link(@pet_3.name)
            click_link(@pet_3.name)
            expect(current_path).to eq("/admin/applications/#{@application_1.id}")
        end 
    end 
end 