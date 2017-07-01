require_relative "ghost_text/version"
require "json"
require "rack"
require "thin"
require "faye/websocket"

Faye::WebSocket.load_adapter("thin")

module Textbringer
  module GhostText
    class App
      def call(env)
        if Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env)

          next_tick do
            buffer = Buffer.new_buffer("*GhostText*")
            switch_to_buffer(buffer)

            ws.on :message do |event|
              data = JSON.parse(event.data)
              next_tick do
                buffer.composite_edit do
                  buffer.delete_region(buffer.point_min, buffer.point_max)
                  buffer.insert(data["text"])
                end
              end
            end

            ws.on :close do |event|
              ws = nil
            end
          end
          ws.rack_response
        else
          json = {
            "WebSocketPort" => 4001,
            "ProtocolVersion" => 1
          }.to_json
          [200, {'Content-Type' => 'application/json'}, [json]]
        end
      end
    end
  end
end

define_command(:ghost_text_start) do
  background do
    thin = Rack::Handler.get("thin")
    thin.run(Textbringer::GhostText::App.new,
             Host: "127.0.0.1", Port: 4001) do |server|
      server.silent = true
    end
  end
end
