class AdminApplicationsController < ApplicationController
    def index 
        
    end 

    def show
        # Thin this out by calling more of the methods in the view?
        @application = Application.find(params[:id])
        @full_address = "#{@application.street_address} #{@application.city}, #{@application.state} #{@application.zipcode}"
        @undetermined_pets = PetApplication.find_undetermined_pets(@application)
        @already_adopted = PetApplication.find_already_adopted_pets(@application)
        @approved_pets = PetApplication.find_approved_pets(@application)
        @rejected_pets = PetApplication.find_rejected_pets(@application)
    end 

    def update 
        application = Application.find(params[:id])
        approved_pets = PetApplication.find_approved_pets(application)
        if params[:approve]
            pet = Pet.find(params[:approve])
            accepted_joins_row = (PetApplication.find_joins_row(application, pet)).first
            accepted_joins_row.Accepted!
            approved_pets = PetApplication.find_approved_pets(application)
            if application.pets == approved_pets
             application.Accepted!
             application.pets.approved_for_adoption
            end
        end 
        if params[:reject]
            pet = Pet.find(params[:reject])
            rejected_joins_row = (PetApplication.find_joins_row(application, pet)).first
            rejected_joins_row.Rejected!
            rejected_pets = PetApplication.find_rejected_pets(application)
            undetermined_pets = PetApplication.find_undetermined_pets(application)
            if undetermined_pets.empty? && rejected_pets.empty? == false
                application.Rejected!
            end 
        end 
        redirect_to "/admin/applications/#{application.id}" 
    end 
end