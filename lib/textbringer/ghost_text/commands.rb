# frozen_string_literal: true

define_command(:ghost_text_start) do
  background do
    thin = Rack::Handler.get("thin")
    thin.run(Textbringer::GhostText::WebSocketServer.new,
             Host: CONFIG[:ghost_text_host],
             Port: CONFIG[:ghost_text_port]) do |server|
      server.silent = true
    end
  end
end
