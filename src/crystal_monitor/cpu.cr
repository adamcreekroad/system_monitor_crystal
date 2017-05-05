require "json"

module CrystalMonitor
  class CPU
    @cpuid   : Int32 | Int64
    @user    : Int32 | Int64
    @nice    : Int32 | Int64
    @system  : Int32 | Int64
    @idle    : Int32 | Int64
    @iowait  : Int32 | Int64
    @irq     : Int32 | Int64

    JSON.mapping(
      cpuid:   Int32 | Int64,
      user:    Int32 | Int64,
      nice:    Int32 | Int64,
      system:  Int32 | Int64,
      idle:    Int32 | Int64,
      iowait:  Int32 | Int64,
      irq:     Int32 | Int64
    )

    def initialize(@cpuid, @user, @nice, @system, @idle, @iowait, @irq)
    end

    def total_idle
      @idle + @iowait
    end

    def total_non_idle
      @user + @nice + @system + @irq + @softirq + @steal
    end

    def total
      total_idle + total_non_idle
    end
  end
end
