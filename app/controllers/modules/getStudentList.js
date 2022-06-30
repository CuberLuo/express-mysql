const connection = require('../../mysql/db')
module.exports = {
  getStudentList: (request, response) => {
    const page = parseInt(request.body.page)
    const size = parseInt(request.body.size) //每页5条数据
    const startIndex = (page - 1) * size //第一页是0
    const sql1 = 'select * from ljt_student_list limit ?,?'
    const sql2 = "select count(*) 'total' from ljt_student_list"
    connection.query(sql1, [startIndex, size], function (results) {
      let stu_list = results
      connection.query(sql2, [], function (results) {
        let total = results[0].total
        response.send({
          code: 10000,
          msg: '获取学生列表数据成功',
          total: total,
          data: stu_list
        })
      })
    })
  }
}
