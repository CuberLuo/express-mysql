const connection = require('../../mysql/db')
module.exports = {
  getAllClass: (request, response) => {
    sql = `
		SELECT Clno 'value', Clname 'label'
		FROM ljt_class
		`
    connection.query(sql, [], function (results) {
      response.send({
        code: 10000,
        data: results
      })
    })
  }
}
