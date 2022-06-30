const express = require('express')
const Mock = require('mockjs')
const app = express()
app.use((request, response, next) => {
  console.log('请求接口:', request.url)
  next()
})

app.get('/', (request, response) => {
  const list = []
  //教师模拟数据
  /* for (let i = 0; i < 20; i++) {
    const obj = Mock.mock({
      Tno: '@integer(10001,50000)',
      Tname: '@cname',
      'Tsex|1': ['男', '女'],
      Tage: '@integer(30,60)',
      'Tlevel|1': ['助教', '讲师', '副教授', '教授'],
      Tphone: '@integer(13111111111,19899999999)'
    })
    list.push(obj)
  } */
  //课程模拟数据
  for (let i = 0; i < 20; i++) {
    const obj = Mock.mock({
      Cno: 'C' + '@integer(100001,999999)',
      Cname: '',
      'CTerm|1': ['1', '2', '3'],
      'Chour|1': ['64', '48', '32'],
      'Cway|1': ['考试', '考查'],
      'Ccredit|1': ['2', '3', '4', '5', '6']
    })
    list.push(obj)
  }
  console.log(JSON.stringify(list))

  response.send({
    code: 10086
  })
})

app.listen(110, (err) => {
  if (!err) {
    console.log('测试服务器启动成功,端口:110')
  }
})
