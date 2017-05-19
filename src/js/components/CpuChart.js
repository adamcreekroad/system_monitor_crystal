import React from 'react';
import PropTypes from 'prop-types';
import { Chart } from 'react-google-charts';

class CpuChart extends React.Component {
  formatCpuUsage() {
    var initialData = ['Time'];
    var currentData = this.props.cpuUsage.slice(0);

    for (let i = 1; i < currentData[0].length; i++) {
      initialData.push(`CPU${i}`);
    }

    currentData.unshift(initialData);

    return currentData;
  }

  render() {
    return (
      <div>
        <Chart
          chartType="LineChart"
          data={this.formatCpuUsage()}
          options={{
            hAxis: { title: 'Time', minValue: 0, maxValue: 60 },
            vAxis: { title: 'Usage', minValue: 0.0, maxValue: 100.0 },
            legend: { position: 'bottom' },
            title: 'Cpu Use',
          }}
          graph_id="LineChart"
          width="100%"
          height="600px"
          legend_toggle
        />
      </div>
    );
  }
}

CpuChart.propTypes = {
  cpuUsage: PropTypes.array,
}

module.exports =  CpuChart;
