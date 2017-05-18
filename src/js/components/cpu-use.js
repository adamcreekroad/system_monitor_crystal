var React = require('react');
var PropTypes = require('prop-types');

class CpuUse extends React.Component {
  render() {
    return(
      <tr id="cpu_{this.props.id}">
        <td className="cpu-id">{this.props.id}</td>
        <td className="cpu-usage">{this.props.usage}%</td>
      </tr>
    )
  }
}

CpuUse.propTypes = {
  id: PropTypes.number.isRequired,
  usage: PropTypes.number.isRequired,
}

module.exports = CpuUse;
