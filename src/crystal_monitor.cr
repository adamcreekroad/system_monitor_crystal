require "./crystal_monitor/*"
require "./system_metrics/*"
require "./views/*"
require "kemal"
require "kilt"

SOCKETS = [] of HTTP::WebSocket

get "/" do
  cpu_usage = SystemMetrics::CPU.new.current_usage.to_json
  mem_usage = SystemMetrics::Memory.new.current_usage.to_json

  Kilt.render("./src/views/monitor.ecr")
end

get "/assets/:asset_name" do |env|
  File.read("./public/assets/#{env.params.url["asset_name"]}")
end

ws "/update" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket
  # Broadcast each message to all clients
  socket.on_message do |message|
    usage = {
      cpuUsage: SystemMetrics::CPU.new.current_usage,
      memUsage: SystemMetrics::Memory.new.current_usage
    }

    if message == "cpu_speeds"
      SOCKETS.each do |socket|
        socket.send usage.to_json
      end
    end
  end
  # Remove clients from the list when it’s closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

Kemal.run
