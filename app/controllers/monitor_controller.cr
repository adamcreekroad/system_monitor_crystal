class MonitorController < ApplicationController
  def index
    @react_props = {
      cpu_usage: SystemMetrics::CPU.new.current_usage.to_json
      mem_usage: SystemMetrics::Memory.new.current_usage.to_json
    }

    render "index"
  end
end
