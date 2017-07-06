# frozen_string_literal: true

define_command(:ghost_text_start) do
  host = CONFIG[:ghost_text_host]
  port = CONFIG[:ghost_text_port]
  message("Start GhostText Server: http://#{host}:#{port}")
  background do
    thin = Rack::Handler.get("thin")
    app = Rack::ContentLength.new(Textbringer::GhostText::Server.new)
    thin.run(app, Host: host, Port: port) do |server|
      server.silent = true
    end
  end
end
