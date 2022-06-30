const controller = {}

controller.login = require('./modules/login').login

controller.register = require('./modules/register').register

controller.getStudentList = require('./modules/getStudentList').getStudentList

controller.getStuScore = require('./modules/getStuScore').getStuScore

controller.getTeacherList = require('./modules/getTeacherList').getTeacherList

controller.getStuRegion = require('./modules/getStuRegion').getStuRegion

controller.submitStuScore = require('./modules/submitStuScore').submitStuScore

controller.getStuListByKeyword =
  require('./modules/getStuListByKeyword').getStuListByKeyword

controller.getCoursesByTno =
  require('./modules/getCoursesByTno').getCoursesByTno

controller.getAllClass = require('./modules/getAllClass').getAllClass

controller.getClassCourse = require('./modules/getClassCourse').getClassCourse

module.exports = controller
