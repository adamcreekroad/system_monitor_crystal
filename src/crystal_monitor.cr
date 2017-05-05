require "./crystal_monitor/*"
require "./system_metrics/*"
require "./views/*"
require "kemal"
require "kilt"

SOCKETS = [] of HTTP::WebSocket

get "/" do
  usage = SystemMetrics::CPU.new.current_usage

  Kilt.render("./src/monitor.ecr")
end

ws "/update" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket
  # Broadcast each message to all clients
  socket.on_message do |message|
    usage = SystemMetrics::CPU.new.current_usage

    if message == "cpu_speeds"
      SOCKETS.each do |socket|
        usage.each do |cpuid, usage|
          socket.send Tuple.new(cpuid, usage).to_json
        end
      end
    end
  end
  # Remove clients from the list when it’s closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

Kemal.run
