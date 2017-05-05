require "json"

module CrystalMonitor
  class CPUStats
    @cpuid      : Int32 | Int64
    @user       : Int32 | Int64
    @nice       : Int32 | Int64
    @system     : Int32 | Int64
    @idle       : Int32 | Int64
    @iowait     : Int32 | Int64
    @irq        : Int32 | Int64
    @softirq    : Int32 | Int64
    @steal      : Int32 | Int64
    @guest      : Int32 | Int64
    @guest_nice : Int32 | Int64
    @total_idle : Int32 | Int64 | Nil
    @total_non_idle : Int32 | Int64 | Nil
    @total : Int32 | Int64 | Nil

    JSON.mapping(
      cpuid:      Int32 | Int64,
      user:       Int32 | Int64,
      nice:       Int32 | Int64,
      system:     Int32 | Int64,
      idle:       Int32 | Int64,
      iowait:     Int32 | Int64,
      irq:        Int32 | Int64,
      softirq:    Int32 | Int64,
      steal:      Int32 | Int64,
      guest:      Int32 | Int64,
      guest_nice: Int32 | Int64,
      total_idle: Int32 | Int64 | Nil,
      total_non_idle: Int32 | Int64 | Nil,
      total: Int32 | Int64 | Nil
    )

    def initialize(@cpuid, @user, @nice, @system, @idle, @iowait, @irq, @softirq, @steal, @guest, @guest_nice)
      total_idle
      total_non_idle
      total
    end

    def total_idle
      @total_idle = @idle + @iowait
    end

    def total_non_idle
      @total_non_idle = @user + @nice + @system + @irq + @softirq + @steal
    end

    def total
      @total = total_idle + total_non_idle
    end
  end
end
