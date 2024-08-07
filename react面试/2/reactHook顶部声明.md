在 React 中，Hooks 必须在函数组件的顶部调用。原因主要有以下几点：

1. 确保 Hooks 的顺序一致性
   React 依赖于 Hooks 的调用顺序来正确地分配和更新状态。如果 Hooks 的调用顺序在不同的渲染过程中发生变化，React 将无法正确地关联状态和副作用，这可能会导致不可预见的行为或错误。
2. 避免在条件语句中调用 Hooks
   在条件语句中调用 Hooks 会破坏 Hooks 的调用顺序，使得 React 无法正确地管理组件的状态和副作用。这是因为每次渲染时，条件语句可能会导致不同的 Hooks 被调用或跳过，从而导致调用顺序的不一致。
3. React 的内部实现依赖于此约定
   React 的内部实现通过一个全局指针（如 currentHook）来跟踪当前正在处理的 Hook。这个指针在每次渲染时都会重置，并在调用每个 Hook 时递增。如果 Hooks 的调用顺序发生变化，这个指针的管理将变得非常复杂和错误频发。

## 为什么需要顺序？

在 React 中，Hooks 必须按照一致的顺序调用，因为 React 依赖于这个顺序来正确地管理组件的状态和副作用。具体来说，每次组件渲染时，React 都会遍历并调用这些 Hooks。如果 Hooks 的调用顺序在不同的渲染过程中发生变化，React 将无法正确地关联状态和副作用，从而导致不可预见的行为或错误。

### 如何处理顺序？

React 通过内部的机制来维护和管理 Hooks 的调用顺序。在每次渲染过程中，React 会依次调用每个 Hook，并将其返回值存储在一个结构中，以便在下次渲染时能正确地访问和更新这些值。

### 顺序存储在哪里？

React 通过 Fiber 数据结构来管理组件的渲染和状态。在 Fiber 架构中，每个组件实例都会对应一个 Fiber 节点，这个节点包含了与该组件相关的所有状态和副作用的信息。

具体实现细节：
Fiber 节点：
每个 Fiber 节点都有一个 memoizedState 属性，用于存储与该组件关联的 Hook 状态。这个 memoizedState 是一个链表，每个节点表示一个 Hook。

当前 Hook 指针：
React 通过一个全局的指针（如 currentlyRenderingFiber 和 workInProgressHook）来跟踪当前正在处理的 Fiber 节点和 Hook。在每次渲染时，React 会重置这个指针，并在每次调用 Hook 时递增，以确保按顺序处理每个 Hook。
