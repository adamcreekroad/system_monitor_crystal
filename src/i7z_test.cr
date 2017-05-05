require "./crystal_monitor/*"

def cpu_stats
  command = "cat /proc/stat"
  io = IO::Memory.new

  Process.run(command, shell: true, output: io)

  if cpus = io.to_s.split("\n")
    cpus = cpus.map do |cpu|
      if md = cpu.match(/cpu(\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+) (\d+)/)
        attrs = [] of Int64 | Int32
        (1...md.size).each do |index|
          attrs << md[index].to_i
        end
        foo = Tuple(Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64).from(attrs)
        CrystalMonitor::CPU.new(*foo).to_json
      end
    end.compact
    puts cpus.to_s if cpus
  # if cpus
  #   (1..cpus.size).each do |index|
  #     puts cpus[index].to_s
  #   end
  # end
  # puts io.to_s
  end
end

cpu_stats
