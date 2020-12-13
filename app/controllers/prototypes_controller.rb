class PrototypesController < ApplicationController
  before_action :move_to_index, except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authenticate_user!, except: [:index, :show, :new, :create]

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    if Prototype.create(prototype_params).valid?
      redirect_to root_path
    else
      redirect_to action: :new
    end
  end


  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update 
      Prototype.find(params[:id]).update(prototype_params)
      redirect_to prototype_path(params[:id])

  end

  def destroy
    Prototype.find(params[:id]).destroy
    redirect_to action: :index
  end



  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in? 
      redirect_to action: :index
    end
  end

  def move_to_index2
    unless user_signed_in? && current_user.id == Prototype.find(params[:id]).user.id
      redirect_to action: :edit
    end
  end

end




=begin def create
  @room = Room.find(params[:room_id])
  @message = @room.messages.new(message_params)
  if @message.save
    redirect_to room_messages_path(@room)
  else
    @messages = @room.messages.includes(:user)
    render :index
  end
=end 