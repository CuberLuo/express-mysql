const connection = require('../../mysql/db')
module.exports = {
  getAvg: (request, response) => {
    const Cno = request.body.Cno
    const Year = request.body.Year
    console.log(Cno, Year)
    const sql = `
		SELECT AVG_SCORE 
		FROM ljt_average_score
		WHERE Cno=? and ScoreYear=?
		`
    connection.query(sql, [Cno, Year], function (results) {
      // console.log(results)
      response.send({
        code: 10000,
        AVG_SCORE: results[0].AVG_SCORE
      })
    })
  }
}
