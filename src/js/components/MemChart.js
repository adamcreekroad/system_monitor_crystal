import React from 'react';
import PropTypes from 'prop-types';
import { Chart } from 'react-google-charts';

class MemChart extends React.Component {
  formatMemUsage() {
    var initialData = ['Time', 'Total', 'Free', 'Available', 'Buffers', 'Cached'];
    var currentData = this.props.memUsage.slice(0);

    currentData.unshift(initialData);

    return currentData;
  }

  render() {
    return (
      <div>
        <Chart
          chartType="LineChart"
          data={this.formatMemUsage()}
          options={{
            hAxis: { title: 'Time (Seconds)', minValue: 0, maxValue: 60 },
            vAxis: { title: 'Usage (GB)', minValue: 0.0, maxValue: 16.0 },
            legend: { position: 'bottom' },
            title: 'Memory Use',
          }}
          graph_id="MemChart"
          width="100%"
          height="600px"
          legend_toggle
        />
      </div>
    );
  }
}

MemChart.propTypes = {
  cpuUsage: PropTypes.array,
}

module.exports =  MemChart;
