import React from 'react';
import PropTypes from 'prop-types';
import CpuChart from './CpuChart.js';
import MemChart from './MemChart.js';

var initializeWebsocket = function(component) {
  var getUpdate = function() {
    websocket.send("cpu_speeds");
    setTimeout(getUpdate, 1000);
  }

  const websocket = new WebSocket("ws://localhost:3003/update");

  websocket.onopen = function(event) {
    getUpdate();
  }

  websocket.onmessage = function(event) {
    var cpuUsage = JSON.parse(event.data).cpuUsage;
    var memUsage = JSON.parse(event.data).memUsage;

    var newCpuUsage = component.updateUsage(component.state.cpuUsage, cpuUsage);
    var newMemUsage = component.updateUsage(component.state.memUsage, memUsage);

    component.updateState(newCpuUsage, newMemUsage);
  }

  websocket.onclose = function(event) {
  }
}

class SystemMonitor extends React.Component {
  constructor(props) {
    super();
    initializeWebsocket(this);

    this.state = {
      cpuUsage: this.initializeUsage(props.cpuUsage),
      memUsage: this.initializeUsage(props.memUsage)
    };
  }

  initializeUsage(usage) {
    var graphValues = Object.values(usage);
    graphValues.unshift(0);

    return [graphValues];
  }

  updateUsage(currentUsage, newUsage) {
    var graphValues = Object.values(newUsage);
    var lastUpdate = currentUsage[currentUsage.length - 1][0];

    if (lastUpdate >= 60) {
      currentUsage.shift();

      for (var i = 0; i < currentUsage.length; i++) {
        currentUsage[i][0] -= 1;
      }
    } else {
      lastUpdate += 1;
    }

    graphValues.unshift(lastUpdate);
    currentUsage.push(graphValues);

    return currentUsage;
  }

  updateState(cpuUsage, memUsage) {
    this.setState(function () {
      return {
        cpuUsage: cpuUsage,
        memUsage: memUsage
      }
    });
  }

  render() {
    return (
      <div>
        <CpuChart cpuUsage={this.state.cpuUsage}/>
        <MemChart memUsage={this.state.memUsage}/>
      </div>
    )
  }
}

SystemMonitor.propTypes = {
  cpuUsage: PropTypes.object,
  memUsage: PropTypes.object,
}

module.exports = SystemMonitor;
