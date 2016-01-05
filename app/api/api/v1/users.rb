module API::V1
  class Users  < Grape::API
    include API::V1::Defaults

    before do
      authenticate!
    end

    helpers do
      def user_params
        clean_params(params).require(:user).permit(:email, :password, :password_confirmation)
      end
    end

    resource :users do
      desc "Return all users"
      get "", root: :users do
        render User.all
      end

      desc "Return a user"
      params do
        requires :id, type: String, desc: "ID of the user"
      end
      get ":id", root: "user" do
        User.where(id: permitted_params[:id]).first!
      end

      desc 'Create a user.'
      params do
        requires :user, type: Hash do
          requires :email
          requires :password
          requires :password_confirmation
        end
      end
      post do
        user = User.new(user_params)
        if user.save
          render user
        else
          error!({ errors: user.errors }, 422)
        end
      end

      desc 'Update a user.'
      params do
        requires :user, type: Hash do
          requires :email
        end
      end
      put ':id' do
        # authenticate!
        user = User.find(params[:id])
        user.attributes = user_params
        if user.save
          render user
        else
          error!({ errors: user.errors }, 422)
        end
      end

      desc 'Delete a user.'
      params do
        requires :id, type: String, desc: 'Users ID.'
      end
      delete ':id' do
        User.find(params[:id]).destroy
      end

    end

  end
end
