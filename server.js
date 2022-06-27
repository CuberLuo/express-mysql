const express = require('express')
const routes = require('./app/routes/index')
const app = express()
// 后端请求拦截器
app.use((request, response, next) => {
  console.log('请求接口:', request.url)
  next()
})
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
// 使用路由
app.use('/', routes)

const PORT = process.env.PORT || 3000
app.listen(PORT, (err) => {
  if (!err) {
    console.log(`Server is running on port ${PORT}`)
    console.log(`http://localhost:${PORT}`)
  }
})
