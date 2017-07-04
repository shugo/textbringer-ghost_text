# frozen_string_literal: true

require "json"
require "rack"
require "thin"
require "faye/websocket"

Faye::WebSocket.load_adapter("thin")

module Textbringer
  module GhostText
    class WebSocketServer
      def call(env)
        if Faye::WebSocket.websocket?(env)
          ws = Faye::WebSocket.new(env, nil,
                                   ping: CONFIG[:ghost_text_ping_interval])

          next_tick do
            buffer = Buffer.new_buffer("*GhostText*")
            switch_to_buffer(buffer)

            remote_text = nil

            buffer.on_modified do
              text = buffer.to_s
              if text != remote_text
                pos = buffer.substring(0, buffer.point).size
                data = {
                  "text" => text,
                  "selections" => [{ "start" => pos, "end" => pos }]
                }
                ws&.send(data.to_json)
                remote_text = text
              end
            end

            ws.on :message do |event|
              data = JSON.parse(event.data)
              next_tick do
                buffer.composite_edit do
                  remote_text = data["text"]
                  buffer.delete_region(buffer.point_min, buffer.point_max)
                  buffer.insert(remote_text)
                  pos = data["selections"]&.dig(0, "start")
                  if pos
                    byte_pos = remote_text[0, pos].bytesize
                    buffer.goto_char(byte_pos)
                  end
                end
              end
            end

            ws.on :close do |event|
              next_tick do
                kill_buffer(buffer, force: true)
              end
              ws = nil
            end
          end
          ws.rack_response
        else
          json = {
            "WebSocketPort" => CONFIG[:ghost_text_port],
            "ProtocolVersion" => 1
          }.to_json
          [200, {'Content-Type' => 'application/json'}, [json]]
        end
      end
    end
  end
end
