module.exports = {
  getRandomString: function (strLen) {
    strLen = strLen || 32 //默认32位
    const myStr =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
    const myStrLen = myStr.length
    let randomString = ''
    for (i = 0; i < strLen; i++) {
      // Math.random()返回[0,1)的浮点数
      randomString += myStr.charAt(Math.floor(Math.random() * myStrLen))
    }
    return randomString
  }
}
