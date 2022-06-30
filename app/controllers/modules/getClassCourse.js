const connection = require('../../mysql/db')
module.exports = {
  getClassCourse: (request, response) => {
    const clno = request.body.clno
    const year = request.body.year
    sql = `
		SELECT clco.Cno,c.Cname,c.CTerm,c.Chour,c.Cway,c.Ccredit FROM 
		ljt_class_course clco,
		ljt_course c WHERE
		clco.Clno=? AND
		clco.ScoreYear like ? AND
		clco.Cno=c.Cno
		`
    connection.query(sql, [clno, '%' + year + '%'], function (results) {
      response.send({
        code: 10000,
        data: results
      })
    })
  }
}
