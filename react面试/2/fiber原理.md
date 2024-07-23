# 前提概念

并行：同一时间执行多个线程
并发：线程（任务）交替执行，充分利用多核 CPU 达到高效的执行效率

# Fiber （任务片段）

进程：计算机分配资源的最小单位
线程：计算机执行任务的最小单元

浏览器（多进程）js（）单线程 16.6ms 绘制一帧

react 团队对 version 15 进行了重构，因为 15 是完全使用的递归，无法中断，要么成功要么失败，长任务就会阻塞

# 步骤

1. jsx -> createElement Function
2. render --- VDOM -> DOM
3. Concurrent mode 并发模式 时间切片、自动批处理、优先级调度
4. Fibers （树）
5. Render & Commit （阶段）
6. 函数组件
7. Hooks

# Diff 算法和 Fiber 架构的协同工作

### Diff 算法的角色

Diff 算法的主要职责是高效地比较新旧虚拟 DOM 树，以找出变化的部分。其目的是最小化对真实 DOM 的更新，从而提升性能。Diff 算法通过以下方式实现：

- 同级比较：假设同一层级的节点会进行对比，不跨层级比较节点。
- Key 属性：通过 key 属性标识每个节点，帮助更准确地找到变化节点

### Fiber 架构的角色

Fiber 架构则是 React 内部的一种数据结构和调度机制，旨在解决大型应用中的性能问题。它的主要职责包括：

- 自动批处理

- 时间切片：将渲染任务拆分成多个小任务，以便在每一帧内处理一部分，利用浏览器的空闲时间进行渲染，避免长时间的阻塞。
- 优先级调度：根据任务的重要性和紧急性分配不同的优先级，确保高优先级任务（如用户输入）优先得到处理。

## 在 React 的更新过程中，Diff 算法和 Fiber 架构是如何协同工作的呢？

以下是一个简化的示例流程：

1. 组件更新触发：

当组件状态或属性发生变化时，会触发一次更新。这时候，React 开始进入 Fiber 架构的工作流程。

2.  Render 阶段（使用 Fiber 架构）：

React 使用 Fiber 架构创建一棵新的 Fiber 树，并在这个过程中逐步比较新旧虚拟 DOM 树。这一步中，Diff 算法被用于比较新旧节点，找出变化部分。
在这个阶段，React 会收集所有需要更新的部分，但不会立即更新真实 DOM。

3. Commit 阶段（使用 Fiber 架构）：
   在收集完所有变化后，React 进入 Commit 阶段。这个阶段是同步执行的，React 会将之前收集的所有变化应用到真实 DOM 上。

# fiber 原理

React Fiber 是 React 16 引入的一种新的协调算法和架构，用于管理和优化渲染过程。Fiber 主要解决的是 React 在处理大型应用中的性能问题，通过将渲染工作拆分成可中断和优先级调度的小任务，从而提高响应性和用户体验。

## Fiber 架构的核心思想

1. 增量渲染：
   Fiber 将渲染工作拆分成多个小任务，每个任务称为一个“单元”（unit of work）。这种增量渲染方式使得 React 可以在执行渲染任务时让出控制权，去处理其他更高优先级的任务，比如用户输入，从而保持界面的流畅性。
2. 优先级调度
   每个更新任务都有一个优先级，React 会根据优先级来调度任务。高优先级任务（如用户交互）会优先执行，而低优先级任务（如后台数据更新）则会延后执行。这样可以确保用户体验的顺畅性。
3. 双缓冲机制
   Fiber 使用双缓冲机制来管理渲染过程。一棵 Fiber 树代表当前正在展示的 UI 状态，另一棵 Fiber 树则用于计算下一个 UI 状态。这种方式使得在渲染新状态时不会影响当前 UI 的显示。

## Fiber 的数据结构

Fiber 是一个轻量级的数据结构，它包含了以下信息：
tag：标记当前 Fiber 的类型，如函数组件、类组件、DOM 节点等。
key：用于标识子节点的唯一性，帮助 React 高效地进行 Diff 操作。
child：指向第一个子 Fiber。
sibling：指向下一个兄弟 Fiber。
return：指向父 Fiber。
stateNode：当前 Fiber 对应的实例或 DOM 节点。
pendingProps 和 memoizedProps：分别存储新旧的属性值。
pendingWorkPriority：当前 Fiber 的优先级。

## 工作流程

React Fiber 的渲染过程分为两个阶段：Reconciliation（协调）阶段和 Commit（提交）阶段。

### Reconciliation 阶段

1. 创建 Fiber 树：
   当一个更新发生时，React 会基于当前的 Fiber 树创建一棵新的 Fiber 树。在这个过程中，React 会比较新旧 Fiber 树（即 Diff），找出需要更新的部分。
2. 分段工作：
   Fiber 树的创建过程是可中断的。在每次渲染工作中，React 会检查是否有更高优先级的任务需要处理。如果有，React 会暂停当前渲染任务，去处理高优先级任务。

### Commit 阶段

1. 应用变化：
   在 Reconciliation 阶段完成后，React 会将新 Fiber 树中的变化应用到实际的 DOM 上。这个过程是同步的，不可中断的。
2. 生命周期方法：
   在应用变化的过程中，React 会调用相应的生命周期方法（如 componentDidMount、componentDidUpdate 等）。

   ```js
   // 定义一个简单的 Fiber 节点
   function FiberNode(tag, key, pendingProps) {
     this.tag = tag;
     this.key = key;
     this.pendingProps = pendingProps;
     this.child = null;
     this.sibling = null;
     this.return = null;
     this.stateNode = null;
     this.pendingWorkPriority = NoWork;
   }

   // 创建 Fiber 树
   const rootFiber = new FiberNode("root", null, null);
   const childFiber = new FiberNode("child", null, null);
   rootFiber.child = childFiber;
   childFiber.return = rootFiber;

   // 开始协调过程
   function beginWork(fiber) {
     // 处理当前 Fiber 节点
     // ...

     // 递归处理子节点
     if (fiber.child !== null) {
       return fiber.child;
     }

     // 递归处理兄弟节点
     while (fiber !== null) {
       completeWork(fiber);
       if (fiber.sibling !== null) {
         return fiber.sibling;
       }
       fiber = fiber.return;
     }

     return null;
   }

   // 完成协调过程
   function completeWork(fiber) {
     // 应用变化到 DOM
     // ...
   }

   // 开始调度
   let nextUnitOfWork = rootFiber;
   function performWork() {
     while (nextUnitOfWork !== null) {
       nextUnitOfWork = beginWork(nextUnitOfWork);
     }
   }

   // 启动调度
   performWork();
   ```

## 可中断渲染（Interruptible Rendering）在 Fiber 中的中断点

（中断点，在优先级调度）

在 React 的 Fiber 架构中，可中断渲染的实现是通过将渲染工作拆分成多个小任务，并在合适的地方进行中断和调度。这个过程主要发生在 Reconciliation（协调）阶段，React 会在此阶段中断当前任务，检查是否有更高优先级的任务需要处理。以下是 Fiber 如何实现可中断渲染的详细解释：

- 工作单元和中断点
  1. 工作单元（Unit of Work）
     Fiber 将渲染任务拆分为多个工作单元，每个工作单元对应一个 Fiber 节点。每次渲染时，React 会处理一个或多个工作单元，并在需要时中断。
  2. 中断点（Yielding）
     在处理每个工作单元的过程中，React 会检查是否有更高优先级的任务需要处理。如果有，React 会中断当前的渲染任务，让出控制权去处理高优先级任务。
     这种中断机制通过在每个工作单元的处理结束后，或在处理过程中显式调用一个检查函数（如 shouldYield）来实现。
