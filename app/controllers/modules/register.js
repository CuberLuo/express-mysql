const connection = require('../../mysql/db')
const crypto = require('crypto')
const randString = require('../../utils/getRandomString')
module.exports = {
  register: (request, response) => {
    const username = request.body.username
    const password = request.body.password

    const md5 = crypto.createHash('md5')
    const sha256 = crypto.createHash('sha256')
    const salt = randString.getRandomString()
    const hashCode = sha256
      .update(md5.update(password).digest('hex') + salt)
      .digest('hex') //加盐后的密码哈希值

    connection.query(
      'select username from ljt_administrator where username=?',
      [username],
      function (results) {
        if (results.length >= 1) {
          response.send({
            code: 10010,
            msg: '该用户名已被注册'
          })
        } else {
          connection.query(
            'insert into ljt_administrator(username,password,salt) values(?,?,?)',
            [username, hashCode, salt],
            function (results) {
              if (results.affectedRows === 1) {
                response.send({
                  code: 10000,
                  msg: '注册成功'
                })
              } else {
                response.send({
                  code: 10020,
                  msg: '注册失败'
                })
              }
            }
          )
        }
      }
    )
  }
}
