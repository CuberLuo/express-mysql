const connection = require('../../mysql/db')
module.exports = {
  submitStuScore: (request, response) => {
    const sno = request.body.sno
    const cno = request.body.cno
    const score = parseInt(request.body.score)
    const year = request.body.year
    const sql = `
		INSERT INTO ljt_stu_score(Sno,Cno,Score,ScoreYear)
		VALUES(?,?,?,?)
		`
    connection.query(sql, [sno, cno, score, year], function (results) {
      if (results.affectedRows === 1) {
        response.send({
          code: 10000,
          msg: '学生成绩录入成功'
        })
      }
    })
  }
}
