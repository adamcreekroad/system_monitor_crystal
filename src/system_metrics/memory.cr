require "yaml"

module SystemMetrics
  class Memory
    COMMAND = "cat /proc/meminfo"

    def initialize
    end

    def get_mem_stats
      io = IO::Memory.new

      Process.run(COMMAND, shell: true, output: io)

      total, free, available, buffers, cached =
        io.to_s.scan(/(Mem\w+|Buffers|Cached):\s+(\d+) kB\n/)

      CrystalMonitor::MemoryStats.new(
        (total[2].to_f * 0.000001).round(2),
        (free[2].to_f * 0.000001).round(2),
        (available[2].to_f * 0.000001).round(2),
        (buffers[2].to_f * 0.000001).round(2),
        (cached[2].to_f * 0.000001).round(2)
      )
    end


    def current_usage
      usage = get_mem_stats

      # usage = {} of String => (Float64 | Nil)
      #
      # (0..(@start_usage.size - 1)).each do |cpuid|
      #   usage[cpuid.to_s] = cpu_usage_for(cpuid)
      # end
      #
      usage
    end
  end
end
