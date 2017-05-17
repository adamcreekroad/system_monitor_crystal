require "./crystal_monitor/*"
require "./system_metrics/*"
require "./views/*"
require "kemal"
require "kilt"

SOCKETS = [] of HTTP::WebSocket

get "/" do
  cpu_usage = SystemMetrics::CPU.new.current_usage
  mem_usage = SystemMetrics::Memory.new.current_usage

  puts mem_usage.to_json

  Kilt.render("./src/views/monitor.ecr")
end

get "/react-monitor" do |env|
  name = env.params.query["name"]
  
  Kilt.render("./src/views/react_monitor.ecr")
end

get "/main" do
  Kilt.render("./main.ecr")
end

get "/src/js/system-monitor.js" do
  File.read("./src/js/system-monitor.js")
end

get "/src/js/require.js" do
  File.read("./src/js/require.js")
end

ws "/update" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket
  # Broadcast each message to all clients
  socket.on_message do |message|
    usage = {
      cpu: SystemMetrics::CPU.new.current_usage,
      mem: SystemMetrics::Memory.new.current_usage
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
