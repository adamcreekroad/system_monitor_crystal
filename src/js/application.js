var React = require('react');
var ReactDOM = require('react-dom');
var SystemMonitor = require('./components/SystemMonitor.js');

var mountComponents = function() {
  let components = $('[data-react-class]');

  for (let component of components) {
    let componentName = eval($(component).attr('data-react-class'));
    let componentProps = JSON.parse($(component).attr('data-react-props'));

    ReactDOM.render(
      React.createElement(componentName, componentProps, null),
      component
    );
  }
}

mountComponents();
