var React = require('react');
var PropTypes = require('prop-types');
var CpuUse = require('./cpu-use.js');
var MemUse = require('./mem-use.js');
var CpuChart = require('./CpuChart.js');

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

    component.updateCpuUsage(cpuUsage);
  }

  websocket.onclose = function(event) {
  }
}

class SystemMonitor extends React.Component {
  constructor(props) {
    super();
    initializeWebsocket(this);

    this.state = {
      cpuUsage: this.initializeCpuUsage(props.cpuUsage),
      memUsage: props.memUsage
    };
  }

  initializeCpuUsage(cpuUsage) {
    var graphValues = Object.values(cpuUsage);
    graphValues.unshift(0);

    return [graphValues];
  }

  updateCpuUsage(cpuUsage) {
    var currentUsage = this.state.cpuUsage;
    var graphValues = Object.values(cpuUsage);
    var lastUpdate = currentUsage[currentUsage.length - 1][0]

    if (lastUpdate < 60) {
      lastUpdate += 1;
      graphValues.unshift(lastUpdate);
      currentUsage.push(graphValues);

      this.updateUsage(currentUsage, this.state.memUsage);
    } else {

    }
  }

  cpus() {
    var cpuList = []

    for (let key in this.state.cpuUsage) {
      var id = parseInt(key);
      var usage = parseFloat(this.state.cpuUsage[key]);
      var reactKey = `cpu-${id}`;

      cpuList.push(<CpuUse id={id} usage={usage} key={reactKey}/>);
    }

    return cpuList;
  }

  mem() {
    var memList = []

    for (let key in this.state.memUsage) {
      var attr = key;
      var usage = parseFloat(this.state.memUsage[key]);
      var reactKey = `mem-${attr}`;

      memList.push(<MemUse attr={key} usage={usage} key={reactKey}/>);
    }

    return memList;
  }

  updateUsage(cpuUsage, memUsage) {
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
      </div>
    )
  }
}

SystemMonitor.propTypes = {
  cpuUsage: PropTypes.object,
  memUsage: PropTypes.object,
}

module.exports = SystemMonitor;
