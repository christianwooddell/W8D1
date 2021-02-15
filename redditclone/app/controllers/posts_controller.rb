class PostsController < ApplicationController
    def new
        @post = Post.new
        render :new
    end

    def show
        @post = Post.find(params[:id])
        render :show
    end

    def create
        @post = Post.create(post_params)
        @post.sub_id = 1
        @post.author_id = current_user.id
        if @post.save
            redirect_to posts_url
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end
    def edit
        @post = Post.find(params[:id])
        render :edit
    end

    def update
        @post = Post.find(params[:id])
        if @post && @post.update(post_params)
            redirect_to sub_url(@post.sub)
        else
            flash.now[:errors] = @post.errors.full_messages
            render :new
        end
    end

    def destroy
        @post = current_user.posts.find_by(id: params[:id])
        if @post && @post.delete
            redirect_to posts_url
        else
            render :show
        end
    end 

    private
    def post_params
        params.require(:post).permit(:title, :url, :content, :sub_id, :author_id)
    end
end
