const connection = require('../../mysql/db')
module.exports = {
  getCoursesByTno: (request, response) => {
    const Tno = request.body.Tno
    sql = 'CALL getCoursesByTno(?)'
    connection.query(sql, [Tno], function (results) {
      console.log(results)
      response.send({
        code: 10000,
        data: results[0]
      })
    })
  }
}
