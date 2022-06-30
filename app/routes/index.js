const router = require('express').Router()
const controller = require('../controllers/index')

router.post('/login', controller.login)

// router.post('/register', controller.register)
router.post('/getStudentList', controller.getStudentList)

router.post('/getStuScore', controller.getStuScore)

router.post('/getTeacherList', controller.getTeacherList)

router.get('/getStuRegion', controller.getStuRegion)

router.post('/submitStuScore', controller.submitStuScore)

router.post('/getStuListByKeyword', controller.getStuListByKeyword)

router.post('/getCoursesByTno', controller.getCoursesByTno)

router.get('/getAllClass', controller.getAllClass)

router.post('/getClassCourse', controller.getClassCourse)

module.exports = router
