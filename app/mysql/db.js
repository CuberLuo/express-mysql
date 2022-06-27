const mysql = require('mysql')
const dbConfig = require('./db.config')
module.exports = {
  query: function (sql, params, callback) {
    const connection = mysql.createConnection(dbConfig)

    connection.connect(function (err) {
      if (err) {
        console.log('数据库连接失败!')
      }
    })

    connection.query(sql, params, function (err, results) {
      if (err) {
        console.log('数据操作失败')
      }
      // console.log(results)
      //将查询出来的数据返回给回调函数
      callback(JSON.parse(JSON.stringify(results)))
    })

    //sql语句执行完毕后关闭数据库连接
    connection.end(function (err) {
      if (err) {
        console.log('关闭数据库连接失败！')
      }
    })
  }
}
