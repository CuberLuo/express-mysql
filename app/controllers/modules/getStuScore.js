const connection = require('../../mysql/db')
module.exports = {
  getStuScore: (request, response) => {
    const Sno = request.body.Sno
    const ScoreYear = request.body.ScoreYear
    // console.log(Sno + ' ' + ScoreYear)
    const sql1 = `
			SELECT s.Cno,c.Cname,s.Score FROM 
			ljt_stu_score s,
			ljt_course c
			WHERE s.Sno=? AND 
			ScoreYear like ? AND
			c.Cno=s.Cno
		`
    connection.query(sql1, [Sno, '%' + ScoreYear + '%'], function (results) {
      var oneResults = results
      var arr = []
      // console.log(oneResults)
      if (oneResults.length === 0) {
        response.send({
          code: 11000,
          data: []
        })
      } else {
        results.forEach((item) => {
          const sql2 = 'CALL getTeachersByCno(?)'
          connection.query(sql2, [item.Cno], function (results) {
            const Teachers = results[0].map((t) => t.Tname)
            item.Teachers = Teachers
            arr.push(item)
            if (arr.length === oneResults.length) {
              response.send({
                code: 10000,
                data: arr
              })
            }
          })
          // console.log(arr.length)
        })
      }
    })
  }
}
