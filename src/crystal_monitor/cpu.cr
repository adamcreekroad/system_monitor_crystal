require "json"

module CrystalMonitor
  class CPU
    @id : Int32
    @name : String
    @speed : Float64

    JSON.mapping(
      id: Int32,
      name: String,
      speed: Float64
    )

    def initialize(@id, @name, @speed)
    end
  end
end
