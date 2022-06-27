const controller = {}

controller.login = require('./modules/login').login

controller.register = require('./modules/register').register

module.exports = controller
