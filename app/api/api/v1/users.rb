module API::V1
  class Users  < Grape::API
    include API::V1::Defaults
    
    before do
      authenticate!
    end

    resource :users do

      desc "Return a user"
      params do
        requires :id, type: String, desc: "ID of the
            user"
      end
      get ":id", root: "user" do
        User.where(id: permitted_params[:id]).first!
      end

    end
  end
end
