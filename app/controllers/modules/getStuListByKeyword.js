const connection = require('../../mysql/db')
module.exports = {
  getStuListByKeyword: (request, response) => {
    const keyword = request.body.keyword
    // console.log(keyword)
    const sql = `
		select * from ljt_student_list where Sno=?
		`
    connection.query(sql, [keyword], function (results) {
      let stu_list = results
      if (results.length === 1) {
        response.send({
          code: 10000,
          msg: '获取学生列表数据成功',
          total: 1,
          data: stu_list
        })
      } else {
        response.send({
          code: 11000,
          msg: '获取学生列表数据失败',
          total: 0
        })
      }
    })
  }
}
