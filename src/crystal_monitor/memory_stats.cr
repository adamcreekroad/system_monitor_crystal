require "json"

module CrystalMonitor
  class MemoryStats
    @total     : Float64
    @free      : Float64
    @available : Float64
    @buffers   : Float64
    @cached    : Float64

    JSON.mapping(
      total:     Float64,
      free:      Float64,
      available: Float64,
      buffers:   Float64,
      cached:    Float64
    )

    def initialize(@total, @free, @available, @buffers, @cached)
    end
  end
end
