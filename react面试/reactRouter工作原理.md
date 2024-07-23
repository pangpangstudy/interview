## 为什么需要前端路由

刷新页面 根据 url 对资源进行重定向

## react-router-dom 有哪些组件

HashROuter BrowserRouter 路由器
Route 路由匹配
Link 链接
NavLink 当前活动链接
Switch 路由的跳转
Redirect 路由重定向

核心能力就是跳转
路由：定义路由和组件的映射关系
导航：负责触发路由的改变

BrowserRouter html5 history api 实现路由跳转
监听 popState 进行路由事件的触发
HashRouter url 的 hash 属性
#XXX--路由
hashChange
