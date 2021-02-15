class SubsController < ApplicationController
    before_action :moderator?, only: [:edit, :update]

    def index
        @subs = Sub.all
        render :index
    end

    def new
        @sub = Sub.new
        render :new
    end

    def show
        @sub = Sub.find(params[:id])
        render :show
    end

    def create
        @sub = Sub.create(sub_params)
        @sub.moderator_id = current_user.id
        if @sub.save
            redirect_to subs_url
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    def edit
        @sub = Sub.find(params[:id])
        render :edit
    end

    def update
        @sub = Sub.find(params[:id])
        if @sub && @sub.update(sub_params)
            redirect_to subs_url
        else
            flash.now[:errors] = @sub.errors.full_messages
            render :new
        end
    end

    private 
    def sub_params
        params.require(:sub).permit(:title, :description, :moderator_id)
    end

    def moderator?
        redirect_to subs_url unless current_user.id == params[:id]
    end
end
