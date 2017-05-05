module SystemMetrics
  class CPU
    COMMAND = "cat /proc/stat"

    @start_usage : Array(CrystalMonitor::CPUStats)
    @finish_usage : Array(CrystalMonitor::CPUStats)

    def initialize
      @start_usage = get_cpu_stats
      sleep(0.5)
      @finish_usage = get_cpu_stats
    end

    def get_cpu_stats
      io = IO::Memory.new

      Process.run(COMMAND, shell: true, output: io)

      cpus = io.to_s.split("\n")

      cpus.map do |cpu|
        next unless cpu =~ /cpu(\d+)/

        md = cpu.match(/cpu(?<cpuid>\d+) (?<user>\d+) (?<nice>\d+) (?<system>\d+) (?<idle>\d+) (?<iowait>\d+) (?<irq>\d+) (?<softirq>\d+) (?<steal>\d+) (?<guest>\d+) (?<guest_nice>\d+)/)

        attrs = [] of Int64 | Int32

        if md
          (1...12).each do |index|
            attrs << md[index].to_i
          end
        end

        foo = Tuple(Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64, Int32 | Int64).from(attrs)
        CrystalMonitor::CPUStats.new(*foo)
      end.compact
    end

    def cpu_usage_for(cpu)
      totald = @start_usage[cpu].total.to_f - @finish_usage[cpu].total.to_f
      idled = @start_usage[cpu].total_idle.to_f - @finish_usage[cpu].total_idle.to_f

      ((totald - idled) / totald * 100).abs.round(2)
    end

    def current_usage
      usage = {} of String => (Float64 | Nil)

      (0..(@start_usage.size - 1)).each do |cpuid|
        usage[cpuid.to_s] = cpu_usage_for(cpuid)
      end

      usage
    end
  end
end
