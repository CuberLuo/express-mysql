const connection = require('../../mysql/db')
module.exports = {
  getStuRank: (request, response) => {
    const Cno = request.body.Cno
    const Sno = request.body.Sno
    const Year = request.body.Year
    // console.log(Cno, Sno, Year)
    const sql = `
		SELECT t.RankNum FROM
		(
			SELECT Sno,Score,
			rank() over(ORDER BY Score DESC) as RankNum FROM
			ljt_stu_score WHERE 
			Cno=? AND ScoreYear=?
			AND Sno IN
			(
				SELECT Sno FROM 
				ljt_student
				WHERE Clno=(SELECT Clno FROM ljt_student WHERE Sno=?)
			)
		) t 
		WHERE t.Sno=?
		`
    connection.query(sql, [Cno, Year, Sno, Sno], function (results) {
      response.send({
        code: 10000,
        rank: results[0].RankNum
      })
    })
  }
}
