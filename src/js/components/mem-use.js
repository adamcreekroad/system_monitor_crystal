var React = require('react');
var PropTypes = require('prop-types');

class MemUse extends React.Component {
  render() {
    return(
      <tr>
        <td>{this.props.attr}</td>
        <td className="mem-{this.props.attr}">{this.props.usage}GB</td>
      </tr>
    )
  }
}

MemUse.propTypes = {
  attr: PropTypes.string.isRequired,
  usage: PropTypes.number.isRequired,
}

module.exports = MemUse;
