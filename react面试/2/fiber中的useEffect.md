在 React 的 Fiber 架构中，useEffect 的执行分为两个阶段：渲染（Render）阶段和提交（Commit）阶段。下面详细介绍每个阶段的工作内容和 useEffect 的执行机制。

## 渲染阶段（Render Phase）

在渲染阶段，React 会进行以下工作：

1. 生成 Fiber 树：

React 会遍历组件树，生成对应的 Fiber 树。
在这个过程中，React 会调用组件函数，执行 useState、useReducer 等 Hook，构建虚拟 DOM。

2.  标记副作用：

当组件中使用 useEffect Hook 时，React 并不会立即执行它，而是将这个副作用标记并存储在当前 Fiber 节点上

## 提交阶段（Commit Phase）

在提交阶段，React 会实际执行副作用，useEffect 就是在这个阶段执行的。提交阶段分为以下几个子阶段：

1. Before Mutation（DOM 更新前）：

React 在实际进行 DOM 操作之前调用生命周期方法，如 getSnapshotBeforeUpdate。

2. Mutation（DOM 更新）：

React 将收集到的所有 DOM 更新应用到真实 DOM 上。

3. Layout（DOM 更新后）：

在 DOM 更新完成后，React 会调用 useLayoutEffect 和组件的 componentDidMount、componentDidUpdate 等生命周期方法。
Passive Effects（被动效果）：

在所有 DOM 更新和同步副作用（即 useLayoutEffect）完成后，React 开始执行被动副作用（即 useEffect）。
这些副作用在一个独立的任务中异步执行，以确保不会阻塞浏览器的绘制。

## 执行细节

useEffect 的执行顺序和机制
首次渲染：

在首次渲染时，useEffect 在 DOM 更新完成后执行。
React 会调度一个异步任务，延迟执行 useEffect，确保它在浏览器完成布局和绘制之后执行。
依赖更新：

在依赖项变化时，React 会在下一次渲染完成后重新执行 useEffect。
如果在渲染过程中检测到依赖项发生变化，React 会先清理上一次的副作用（调用 useEffect 返回的清理函数），然后调度新的副作用执行。
