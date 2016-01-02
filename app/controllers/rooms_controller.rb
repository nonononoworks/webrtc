class RoomsController < ApplicationController

  def index
    @rooms = Room.where(:public => true).order("created_at DESC")
    @new_room = Room.new
  end

  def create
    config_opentok
    session = @opentok.create_session #request.remote_addr
    params[:room][:sessionId] = session.session_id

    @new_room = Room.new(user_params)

    respond_to do |format|
      if @new_room.save
        format.html { redirect_to("/party/"+@new_room.id.to_s) }
      else
        format.html { render :controller => 'rooms',
                             :action => "index" }
      end
    end
  end

  def party
    @room = Room.find(params[:id])

    config_opentok

    @tok_token = @opentok.generate_token @room.sessionId
  end

  private
    def user_params
      params.require(:room).permit( :name,:sessionId,:public)
    end
    def config_opentok
      if @opentok.nil?
        @opentok = OpenTok::OpenTok.new 45454202, "332554d124a29669a50ef0503011917f0bc801b2"
      end
    end
end
