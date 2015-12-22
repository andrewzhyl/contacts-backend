module API::V1
  class Contacts  < Grape::API
    include API::V1::Defaults

    # before do
    #   authenticate!
    # end

    helpers do
      def contact_params
        clean_params(params).require(:contacts).permit(:first_name, :last_name)
      end
    end

    resource :contacts do
      desc "Return all contacts"
      get "", root: :contacts do
        render Contact.all
      end

      desc "Return a contact"
      params do
        requires :id, type: String, desc: "ID of the contact"
      end
      get ":id", root: "contact" do
        Contact.where(id: permitted_params[:id]).first!
      end

      desc 'Create a contact.'
      params do
        requires :status, type: String, desc: 'Your status.'
      end
      post do
        # authenticate!
        Contact.create!(contact_params)
      end

      # desc 'Update a status.'
      # params do
      #   requires :id, type: String, desc: 'Status ID.'
      #   requires :status, type: String, desc: 'Your status.'
      # end
      # put ':id' do
      #   authenticate!
      #   current_user.statuses.find(params[:id]).update({
      #                                                    user: current_user,
      #                                                    text: params[:status]
      #   })
      # end

      # desc 'Delete a status.'
      # params do
      #   requires :id, type: String, desc: 'Status ID.'
      # end
      # delete ':id' do
      #   authenticate!
      #   current_user.statuses.find(params[:id]).destroy
      # end

    end
  end
end
