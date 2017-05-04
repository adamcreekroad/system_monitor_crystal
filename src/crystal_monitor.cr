require "./crystal_monitor/*"
require "./views/*"
require "kemal"
require "kilt"

SOCKETS = [] of HTTP::WebSocket

get "/" do
  cpus = cpu_speeds

  Kilt.render("./src/monitor.ecr")
end

ws "/update" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket
  # Broadcast each message to all clients
  socket.on_message do |message|
    if message == "cpu_speeds"
      SOCKETS.each do |socket|
        cpu_speeds.each do |cpu|
          socket.send cpu.to_json.to_s
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

def cpu_speeds
  command = "cat /proc/cpuinfo"
  io = IO::Memory.new

  Process.run(command, shell: true, output: io)

  cpus = io.to_s.split("\n\n")

  parsed_cpus = cpus.map do |i|
    id    = i.match(/processor\t+: (\d+)\n/)
    name  = i.match(/model name\t+: (.*)\n/)
    speed = i.match(/cpu MHz\t+: (\d+\.\d+)\n/)

    if id && name && speed
      CrystalMonitor::CPU.new(id[1].to_i , name[1].to_s, speed[1].to_f)
    else
      nil
    end
  end
end
