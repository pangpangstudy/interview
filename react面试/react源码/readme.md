# react 理念

状态驱动视图

1. IO 卡顿 ErrorBoundary (react-error-handle) 错误边界 类组件 生命周期
2. CPU 卡顿 刷新频率

## 页面卡顿如何解决？

```js
<ul>
  {Array(300000)
    .fill(null)
    .map((item, i) => {
      <li key={i}>{i}</li>;
    })}
</ul>
```

时间切片：update 的过程进行碎片化
长任务拆分为短任务合集
同步阻塞渲染--->异步非阻塞 用户优先级渲染

ReactDOM.createRoot() 默认开启 concurrent mode ：长任务拆分为短任务合集

- React15

1. reconciler 协调器 diff 找到谁发生变化
   1. update
   2. component render jsx -> VDOM（本质就是对象） (w3c DOM 规范会有很多 diff 不需要的属性 所以使用虚拟 DOM-->对象方式表达节点)
   3. 将本次的 VDOM 与上次 VDOM 比对 diff
   4. 找到变化
   5. 通知 renderer 渲染
2. render 渲染器 将变化的组件渲染到视图中
   1. ReactDOM 跨平台框架
   2. ReactNative
3. scheduler 调度器(优先级执行，将高优先级的任务传给 reconciler)

问题：递归更新子组件，更新的时候是同步更新

- React 16
  异步可中断

1. requestIdleCallback 在浏览器空余的时候调用回调（缺点：兼容性问题）
2. reconciler
   react 自己实现了一份，保证了兼容性

异步可中断：
<--Scheduler：
全部在内存中执行<-
<--reconciler：会根据 Scheduler 下发的任务，Reconciler 会针对 VDOM 代表 replacement deletion update

<!-- 到这里就是同步执行DOM了，所以异步可中断是对于Scheduler：到reconciler：（这里可以随意中断） -->
<!-- 发生更新：针对VDOM打update标记(异步可中断)，打完开始更新（renderer：针对有标记的元素 进行更新）（同步） -->

renderer：
