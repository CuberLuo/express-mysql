const connection = require('../../mysql/db')
const crypto = require('crypto')
module.exports = {
  login: (request, response) => {
    const username = request.body.username
    const password = request.body.password

    connection.query(
      'select username,password,salt from ljt_administrator where username=?',
      [username],
      function (results) {
        if (results.length == 0) {
          response.send({
            code: 10010,
            msg: '用户名不存在'
          })
        } else {
          const md5 = crypto.createHash('md5')
          const sha256 = crypto.createHash('sha256')
          const salt = results[0].salt
          const hashCode = sha256
            .update(md5.update(password).digest('hex') + salt)
            .digest('hex')
          const userHashCode = results[0].password
          if (userHashCode == hashCode) {
            response.send({
              code: 10000,
              msg: '登录成功',
              data: {
                token: '661fe75115e45a3520ec74121898e2af'
              }
            })
          } else {
            response.send({
              code: 10020,
              msg: '密码错误'
            })
          }
        }
      }
    )
  }
}
