require 'rails_helper'

RSpec.describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many(:pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:rank) }
    it { should validate_numericality_of(:rank) }
  end

  before(:each) do
    PetApplication.destroy_all
    Shelter.destroy_all
    Pet.destroy_all
    @application_1 = Application.create!(name: "Sedan Turtle", street_address: "3425 Gransfield ave", city: "Denver", state: "CO", zipcode: "80219", status: "Pending")
    @application_2 = Application.create!(name: "lomein Smurtle", street_address: "3425 Gransfield ave", city: "Denver", state: "CO", zipcode: "80219", status: "In Progress")
    @application_3 = Application.create!(name: "deman Durtle", street_address: "3425 Gransfield ave", city: "Denver", state: "CO", zipcode: "80219", status: "Pending")

    @shelter_1 = Shelter.create(name: 'Zurora shelter', city: 'Aurora', foster_program: false, rank: 9, street_address: "214 w placid", state: "CO", zipcode: "82743")
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Sancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @application_1.pets << @pet_2
    @application_3.pets << @pet_3
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Shelter.search("Sancy")).to eq([@shelter_3])
      end
    end

    describe '#order_by_recently_created' do
      it 'returns shelters with the most recently created first' do
        expect(Shelter.order_by_recently_created).to eq([@shelter_3, @shelter_2, @shelter_1])
      end
    end

    describe '#order_by_number_of_pets' do
      it 'orders the shelters by number of pets they have, descending' do
        expect(Shelter.all).to eq([@shelter_1, @shelter_2, @shelter_3])
        expect(Shelter.order_by_number_of_pets).to eq([@shelter_1, @shelter_3, @shelter_2])
      end
    end

    describe '#reverse_alphabetical_shelters' do 
      it 'orders the shelters by name, descending' do 
        expect(Shelter.reverse_alphabetical_shelters).to eq([@shelter_1, @shelter_3, @shelter_2])
      end 
    end

    describe '#shelters_with_pending_apps' do 
      it 'retrieves all shelters with pending applications alphabetically' do
        expect(Shelter.alphabetical_shelters_with_pending_apps).to eq([@shelter_3, @shelter_1])
      end 
    end 

    describe '.name_and_full_address' do
      it 'can find a shelters full address' do 
      expect(Shelter.name_and_full_address(@shelter_1)).to eq("Name: #{@shelter_1.name}, Address: #{@shelter_1.street_address} #{@shelter_1.city}, #{@shelter_1.state} #{@shelter_1.zipcode}")
      end 
    end 
  end 

  describe 'instance methods' do
    describe '.adoptable_pets' do
      it 'only returns pets that are adoptable' do
        expect(@shelter_1.adoptable_pets).to eq([@pet_2, @pet_4])
      end
    end

    describe '.alphabetical_pets' do
      it 'returns pets associated with the given shelter in alphabetical name order' do
        expect(@shelter_1.alphabetical_pets).to eq([@pet_4, @pet_2])
      end
    end

    describe '.shelter_pets_filtered_by_age' do
      it 'filters the shelter pets based on given params' do
        expect(@shelter_1.shelter_pets_filtered_by_age(5)).to eq([@pet_4])
      end
    end

    describe '.pet_count' do
      it 'returns the number of pets at the given shelter' do
        expect(@shelter_1.pet_count).to eq(3)
      end
    end
  end
end
