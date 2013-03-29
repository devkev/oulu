class NickCommand < Command
  include AuthenticationHelper
  register_command :NICK

  NICK_REGEX = /^[a-zA-Z0-9\[\]`_\-\^{\|}]+$/

  def set_data(args)
    @new_nick = args.first
  end

  def valid?
    !!@new_nick
  end

  def execute!
    if registered? or !@new_nick.match(NICK_REGEX)
      send_reply(render_nick_error(@new_nick))
    else
      irc_connection.nick = @new_nick
      if registered? and !irc_connection.last_ping_sent
        registration_done
        irc_connection.ping!
      end
    end
  end
end
