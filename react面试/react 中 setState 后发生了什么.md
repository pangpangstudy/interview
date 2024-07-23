1. 合并新状态
   当你调用 setState 时，React 会将你传递的状态对象与当前的状态合并。这是一个浅合并过程，只会替换传入对象中的状态，而不会改变未传入的状态。

2. 触发调度
   React 会将状态更新请求放入一个队列中，并在之后的调度周期中处理这些更新。这个过程可以优化多个 setState 调用的合并，减少不必要的重新渲染。

3. 标记 Fiber 树
   在 React Fiber 架构中，每个组件实例都有一个对应的 Fiber 节点。当状态更新时，React 会标记受影响的 Fiber 节点，这些节点会在接下来的调度周期中重新计算。

4. 调度更新（调和过程）
   在调和（Reconciliation）过程中，React 会比较新旧虚拟 DOM 树，找出变化的部分，并生成更新操作。这个过程分为两个阶段：
   Render 阶段
   创建新的虚拟 DOM 树：React 调用组件的 render 方法，生成新的虚拟 DOM 树。
   Diff 算法：React 使用 Diff 算法比较新旧虚拟 DOM 树，找出变化的部分，并标记需要更新的 Fiber 节点。
   Commit 阶段
   应用变化：在这个阶段，React 会将之前计算出的差异应用到真实 DOM 上。这个阶段分为三个子阶段：
   Before Mutation：在实际 DOM 操作之前执行，主要用于获取 DOM 元素的快照。
   Mutation：进行实际的 DOM 操作，更新元素、属性、样式等。
   Layout：在所有 DOM 更新操作完成后执行，可以用于布局和测量等操作。
5. 执行副作用
   useEffect 和 useLayoutEffect：在 DOM 更新完成后，React 会执行在这些 Hooks 中定义的副作用。useEffect 在浏览器绘制后异步执行，而 useLayoutEffect 在所有 DOM 变更后但在浏览器绘制前同步执行。
