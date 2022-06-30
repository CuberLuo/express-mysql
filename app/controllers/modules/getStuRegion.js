const connection = require('../../mysql/db')
module.exports = {
  getStuRegion: (request, response) => {
    sql = `
		SELECT count(*) AS 'value',Sregion AS 'name'
		FROM ljt_student GROUP BY Sregion
		`
    connection.query(sql, [], function (results) {
      // console.log(results)
      response.send({
        code: 10000,
        data: results
      })
    })
  }
}
