# frozen_string_literal: true

require "json"
require "rack"
require "thin"
require "faye/websocket"

Faye::WebSocket.load_adapter("thin")

module Textbringer
  module GhostText
    class Server
      def call(env)
        if Faye::WebSocket.websocket?(env)
          accept_client(env)
        else
          json = {
            "WebSocketPort" => CONFIG[:ghost_text_port],
            "ProtocolVersion" => 1
          }.to_json
          [200, {'Content-Type' => 'application/json'}, [json]]
        end
      end

      private

      def accept_client(env)
        ws = Faye::WebSocket.new(env, nil,
                                 ping: CONFIG[:ghost_text_ping_interval])

        next_tick do
          buffer = Buffer.new_buffer("*GhostText*")
          switch_to_buffer(buffer)

          syncing_from_remote_text = false

          buffer.on_modified do
            unless syncing_from_remote_text
              pos = buffer.substring(0, buffer.point).size
              data = {
                "text" => buffer.to_s,
                "selections" => [{ "start" => pos, "end" => pos }]
              }
              ws&.send(data.to_json)
            end
          end

          buffer.on_killed do
            ws&.close
          end
          
          ws.on :message do |event|
            data = JSON.parse(event.data)
            next_tick do
              syncing_from_remote_text = true
              begin
                buffer.composite_edit do
                  buffer.delete_region(buffer.point_min, buffer.point_max)
                  buffer.insert(data["text"])
                  pos = data["selections"]&.dig(0, "start")
                  if pos
                    byte_pos = data["text"][0, pos].bytesize
                    buffer.goto_char(byte_pos)
                  end
                end
              ensure
                syncing_from_remote_text = false
              end
            end
          end
          
          ws.on :close do |event|
            ws = nil
            next_tick do
              kill_buffer(buffer, force: true)
            end
          end
        end
        ws.rack_response
      end
    end
  end
end
