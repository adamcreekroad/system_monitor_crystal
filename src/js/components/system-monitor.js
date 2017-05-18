var React = require('react');
var PropTypes = require('prop-types');
var CpuUse = require('./cpu-use.js');
var MemUse = require('./mem-use.js');

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

    component.updateUsage(cpuUsage, memUsage);
  }

  websocket.onclose = function(event) {
  }
}

class SystemMonitor extends React.Component {
  constructor(props) {
    super();
    initializeWebsocket(this);

    this.state = {
      cpuUsage: props.cpuUsage,
      memUsage: props.memUsage
    };
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
        <table>
          <thead>
            <tr>
              <th>Processor ID</th>
              <th>Usage</th>
            </tr>
          </thead>
          <tbody>
            {this.cpus()}
          </tbody>
        </table>
        <table>
          <thead>
            <tr>
              <th>Memory</th>
              <th>Amount</th>
            </tr>
          </thead>
          <tbody>
            {this.mem()}
          </tbody>
        </table>
      </div>
    )
  }
}

SystemMonitor.propTypes = {
  cpuUsage: PropTypes.object,
  memUsage: PropTypes.object,
}

module.exports = SystemMonitor;
