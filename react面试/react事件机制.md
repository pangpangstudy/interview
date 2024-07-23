### 什么事合成事件

事件触发 事件冒泡 事件捕获 事件合成 派发

作用：
底层磨平不同浏览器之间的差异 暴露稳定 统一 与 原生事件相同的接口
把握主动权 中心化控制
引入事件池 避免频繁的创建与销毁

与原生 DOM 事件区别
包含对原生 dom 事件引用

### dom 事件流如何工作？

1. 事件捕获
2. 处于目标元素
3. 事件冒泡

React16 事件委托 绑定在 document
React17 事件委托 绑定在 container ReactDom.render(app,container) 减少内存开销

1. 事件绑定在 container 上
2. react 自身实现了冒泡机制 不能通过 return false 实现 阻止冒泡
3. 通过 SyntheticEvent 实现事件合成
