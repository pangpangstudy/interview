## Portal

让组件能够渲染在除了父组件之外的 DOM 节点上，比如 body doc

```js
ReactDom.createPortal(child, container);
```

eg:弹框 提示框

## Fragment

包裹子组件 不产生额外的 dom 节点的方法

## Context

跨层级组件数据传递
props

## Transition

react18 引入并发特性，允许操作被中断
