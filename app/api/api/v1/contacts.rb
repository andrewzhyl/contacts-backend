module API::V1
  class Contacts  < Grape::API
    include API::V1::Defaults

    before do
      authenticate!
    end

    helpers do
      def contact_params
        clean_params(params).require(:contact).permit(:username, :email, :phone_number)
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
        requires :contact, type: Hash do
          requires :username
          requires :email
          requires :phone_number
        end
      end
      post do
        # authenticate!
        contact = Contact.new(contact_params)
        if contact.save
          render contact
        else
          error!({ errors: contact.errors }, 422)
        end
      end

      desc 'Update a status.'
        params do
        requires :contact, type: Hash do
          requires :username
          requires :email
          requires :phone_number
        end
      end
      put ':id' do
        # authenticate!
          contact = Contact.find(params[:id])
          contact.attributes = contact_params
          if contact.save
            render contact
          else
             error!({ errors: contact.errors }, 422)
          end
      end

      desc 'Delete a status.'
      params do
        requires :id, type: String, desc: 'Contacts ID.'
      end
      delete ':id' do
        # authenticate!
        # current_user.statuses.find(params[:id]).destroy
        Contact.find(params[:id]).destroy
      end

    end
  end
end
