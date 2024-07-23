## Fiber（数据结构）

Fiber React 是 React 框架中的一个新架构，引入了“Fiber”作为核心算法，用于处理 React 组件的更新和渲染。Fiber 架构的设计旨在解决一些在 React 早期版本中存在的问题，尤其是在处理复杂更新时的性能和响应性问题。以下是对 Fiber React 的详细解释：

1. Fiber 的定义
   Fiber 是一种数据结构，用于描述 React 树中的每个组件。它是一种可重用的工作单元，能够高效地处理和协调组件更新。

2. 主要目标
   Fiber 的主要目标是提高 React 的可响应性和性能，特别是在处理大型和复杂应用程序时。具体包括：

可中断的渲染：允许 React 在处理繁重的更新时，能够分段进行工作，并在需要时暂停和恢复。这有助于保持应用的流畅性和响应性。
优先级调度：为不同类型的更新分配不同的优先级，以便关键更新（如用户输入）可以比次要更新（如网络请求的数据更新）更快地完成。
更好的错误处理：改进错误边界，允许在组件树的某些部分出错时，不影响其他部分的正常渲染。 3. Fiber 的工作原理
Fiber 架构将更新过程分为两个阶段：

协调（Reconciliation）阶段：确定哪些部分需要更新。这个过程是可中断的，允许 React 在处理过程中暂停以响应用户交互。
提交（Commit）阶段：将更新应用到 DOM 中。这个过程是同步的、不可中断的，因为它需要保证更新的一致性。 4. 协调阶段的细节
在协调阶段，React 会遍历 Fiber 树，并对比当前树与新的更新（虚拟 DOM）之间的差异。这种遍历是深度优先的，React 会创建新的 Fiber 节点来表示更新的部分。这一阶段的工作可以被拆分为更小的任务，允许在必要时进行暂停和恢复。

5. 提交阶段的细节
   一旦协调阶段完成，React 会进入提交阶段，将变化应用到实际的 DOM 中。这包括更新 DOM 节点、添加或移除事件监听器等。这一阶段必须一次性完成，以确保更新的一致性和正确性。

6. 影响和优势
   更好的性能：通过可中断的渲染和优先级调度，Fiber 提升了复杂应用中的性能，尤其是在处理大量更新时。
   更流畅的用户体验：用户交互（如输入和点击）可以得到更及时的响应，减少卡顿和延迟。
   改进的错误处理：增强的错误边界处理，允许在某些组件出错时，不影响整个应用的运行。
   Fiber 架构是 React 发展的一个重要里程碑，使其在处理复杂和动态更新方面变得更加高效和灵活。
   React Fiber 的核心在于它的数据结构和算法，用于管理和协调组件树的更新。以下是对 React Fiber 关键源码部分的详细解释：

7. Fiber 数据结构
   Fiber 数据结构是 React 树中每个组件的表示，包含了组件的各种信息。关键字段包括：

```js
function FiberNode(tag, pendingProps, key, mode) {
  // 标记类型，例如函数组件、类组件、宿主组件等
  this.tag = tag;

  // 组件的属性
  this.pendingProps = pendingProps;

  // 组件的唯一标识符，用于优化
  this.key = key;

  // 工作模式，例如是否启用并发模式
  this.mode = mode;

  // 连接树结构
  this.child = null;
  this.sibling = null;
  this.return = null;
}
```

1. Work Loop
   Work Loop 是 React Fiber 中的核心循环，用于调度和处理更新。React 会在空闲时间段执行这段代码，以分段完成更新任务。

```js
function workLoopSync() {
  // 持续从工作队列中获取下一个工作单元并执行
  while (workInProgress !== null) {
    performUnitOfWork(workInProgress);
  }
}
```

3. performUnitOfWork
   该函数处理每个单独的工作单元，并返回下一个要处理的工作单元。它包含了协调（Reconciliation）阶段的主要逻辑。

```js
function performUnitOfWork(unitOfWork) {
  const current = unitOfWork.alternate;

  let next;
  if (unitOfWork.tag === ClassComponent) {
    next = updateClassComponent(current, unitOfWork);
  } else if (unitOfWork.tag === FunctionComponent) {
    next = updateFunctionComponent(current, unitOfWork);
  } else if (unitOfWork.tag === HostComponent) {
    next = updateHostComponent(current, unitOfWork);
  }

  // 如果存在子节点，则返回第一个子节点作为下一个工作单元
  if (next === null) {
    completeUnitOfWork(unitOfWork);
  }

  return next;
}
```

4. completeUnitOfWork
   这个函数在当前工作单元完成时调用，处理副作用并将控制权返回给父节点，继续处理兄弟节点。

```js
function completeUnitOfWork(unitOfWork) {
  let completedWork = unitOfWork;

  do {
    const returnFiber = completedWork.return;
    const siblingFiber = completedWork.sibling;

    // 处理完成的节点
    // ...

    if (siblingFiber !== null) {
      return siblingFiber;
    }

    completedWork = returnFiber;
  } while (completedWork !== null);
}
```

5.  调度优先级
    React Fiber 允许对不同类型的更新分配不同的优先级，以确保关键任务得到及时处理。

```js
function scheduleUpdateOnFiber(fiber, lane, eventTime) {
  // 将更新添加到更新队列中
  // 根据优先级调度任务
  const root = markUpdateLaneFromFiberToRoot(fiber, lane);

  // 调度更新
  ensureRootIsScheduled(root);
}
```

6. 时间切片和并发模式
   React Fiber 利用浏览器的 requestIdleCallback 或 requestAnimationFrame 来实现时间切片，使得渲染过程可以在浏览器空闲时间段内执行。

```js
function performConcurrentWorkOnRoot(root) {
  // 判断是否有空闲时间
  if (shouldYield()) {
    // 有空闲时间，暂停工作，稍后继续
    requestIdleCallback(performConcurrentWorkOnRoot.bind(null, root));
    return;
  }

  // 继续工作
  workLoopConcurrent();
}
```

7. 提交阶段
   协调阶段完成后，React 进入提交阶段，将所有更新应用到 DOM 中。这一阶段是同步的。

```js
function commitRoot(root) {
  // 确保更新的同步应用
  const finishedWork = root.finishedWork;

  // 应用 DOM 变更
  commitPlacement(finishedWork);
  commitWork(finishedWork);

  // 清理和完成工作
  root.finishedWork = null;
}
```

总结
React Fiber 的源码复杂且精细，设计了许多机制以优化性能和响应性。以上介绍了几个关键部分，包括 Fiber 数据结构、工作循环、调度优先级、时间切片和提交阶段。理解这些部分可以帮助更好地理解 React 的工作原理和性能优化策略。

### 双缓存机制

React Fiber 的双缓存机制（Double Buffering）是一种优化技术，用于在协调（Reconciliation）和提交（Commit）阶段之间分离工作，以提高性能和响应性。这个机制通过创建两个 Fiber 树来管理组件的更新和渲染：当前树（Current Tree）和工作进展树（Work-in-Progress Tree）。
双缓存机制的工作原理

1. 当前树（Current Tree）与工作进展树（Work-in-Progress Tree）
   当前树（Current Tree）：表示当前正在屏幕上显示的 UI 树。
   工作进展树（Work-in-Progress Tree）：表示正在进行更新的树，当更新完成后，这棵树将成为新的当前树。

在任何给定时间，React 只会有一棵树作为“当前树”，而另一棵树则用来处理新的更新。当工作进展树完成所有更新后，它将被“交换”成当前树，而原来的当前树将被重新用作下一轮更新的工作进展树。

2. 创建工作进展树
   在处理更新时，React 会创建工作进展树，并在其上执行所有协调工作。这棵树包含了更新后的组件状态。

```js
function createWorkInProgress(current, pendingProps) {
  let workInProgress = current.alternate;
  if (workInProgress === null) {
    // 创建一个新的工作进展树节点
    workInProgress = new FiberNode(
      current.tag,
      pendingProps,
      current.key,
      current.mode
    );
    workInProgress.stateNode = current.stateNode;
    workInProgress.alternate = current;
    current.alternate = workInProgress;
  } else {
    // 重用现有的工作进展树节点
    workInProgress.pendingProps = pendingProps;
    workInProgress.effectTag = NoEffect;
  }
  workInProgress.child = current.child;
  workInProgress.sibling = current.sibling;
  workInProgress.return = current.return;
  return workInProgress;
}
```

3. 交换树
   一旦协调阶段完成，React 将工作进展树“提交”成当前树。这意味着工作进展树的所有更新将应用到真实的 DOM 中，并且它将成为新的当前树。

```js
function commitRoot(root) {
  const finishedWork = root.finishedWork;

  // 应用所有更新
  commitPlacement(finishedWork);
  commitWork(finishedWork);

  // 交换树
  root.current = finishedWork;
  root.finishedWork = null;
}
```

具体过程
开始更新：React 开始在工作进展树上执行更新。
协调阶段：在工作进展树上执行协调操作，创建新的 Fiber 节点并确定哪些部分需要更新。
提交阶段：将工作进展树的更新应用到 DOM 中，并将其设为当前树。
交换树：原来的当前树变成新的工作进展树，用于下一个更新循环。
优点
提高性能：通过在工作进展树上处理更新，可以避免直接操作 DOM，提高性能。
增强响应性：工作进展树的协调阶段是可中断的，这意味着 React 可以在处理更新的过程中暂停，以响应用户交互，增强应用的响应性。
双缓存机制是 React Fiber 设计的核心部分，使得 React 可以更高效、更灵活地处理复杂的 UI 更新需求。

## Fiber 链表

React Fiber 使用了一种基于链表的数据结构来表示组件树中的每个节点，这种结构使得 Fiber 树中的节点能够更高效地进行遍历和更新。每个 Fiber 节点不仅包含对其子节点的引用，还包含对其兄弟节点和父节点的引用，从而形成一个双向链表。

Fiber 链表结构
每个 Fiber 节点包含以下关键字段，这些字段用于维护 Fiber 树的结构：

```javascript
function FiberNode(tag, pendingProps, key, mode) {
  // 节点类型，例如函数组件、类组件、宿主组件等
  this.tag = tag;

  // 组件的属性
  this.pendingProps = pendingProps;

  // 组件的唯一标识符，用于优化
  this.key = key;

  // 工作模式，例如是否启用并发模式
  this.mode = mode;

  // 连接树结构
  this.child = null; // 第一个子节点
  this.sibling = null; // 下一个兄弟节点
  this.return = null; // 父节点
  this.alternate = null; // 当前 Fiber 节点的备用节点，用于双缓存机制

  // ...
}
```

Fiber 链表的遍历和更新
React 通过遍历 Fiber 链表来处理协调（Reconciliation）和提交（Commit）阶段的更新。以下是主要的遍历和更新操作：

1. 创建和更新子节点
   在 performUnitOfWork 函数中，React 根据当前的 Fiber 节点创建或更新其子节点：

```javascript
function performUnitOfWork(unitOfWork) {
  const current = unitOfWork.alternate;
  let next;

  switch (unitOfWork.tag) {
    case ClassComponent:
      next = updateClassComponent(current, unitOfWork);
      break;
    case FunctionComponent:
      next = updateFunctionComponent(current, unitOfWork);
      break;
    case HostComponent:
      next = updateHostComponent(current, unitOfWork);
      break;
    // 处理其他类型的节点
  }

  if (next === null) {
    completeUnitOfWork(unitOfWork);
  }

  return next;
}
```

1. 完成工作单元
   在 completeUnitOfWork 函数中，React 处理已经完成的工作单元，并移动到下一个兄弟节点或返回父节点：

```javascript
function completeUnitOfWork(unitOfWork) {
  let completedWork = unitOfWork;

  do {
    const returnFiber = completedWork.return;
    const siblingFiber = completedWork.sibling;

    // 处理完成的节点，例如附加副作用
    // ...

    if (siblingFiber !== null) {
      return siblingFiber;
    }

    completedWork = returnFiber;
  } while (completedWork !== null);
}
```

链表结构的优点
高效遍历：链表结构允许 React 以 O(1) 的时间复杂度找到下一个兄弟节点或父节点，从而提高遍历效率。
灵活更新：链表结构使得 React 可以在不需要重建整个树的情况下，对树中的某些部分进行更新和重排。
简化操作：通过维护父节点和子节点的引用，链表结构简化了树操作，例如插入、删除和移动节点。
例子：Fiber 节点的结构
假设我们有一个简单的组件树：

```jsx
<App>
  <Header />
  <Main>
    <Sidebar />
    <Content />
  </Main>
  <Footer />
</App>
```

对应的 Fiber 链表结构如下：

css
复制代码
App
├── Header
├── Main
│ ├── Sidebar
│ └── Content
└── Footer
每个节点包含指向其子节点 (child)、兄弟节点 (sibling) 和父节点 (return) 的引用：

```javascript

const AppFiber = {
  tag: HostComponent,
  child: HeaderFiber,
  sibling: null,
  return: null,
  ...
};

const HeaderFiber = {
  tag: HostComponent,
  child: null,
  sibling: MainFiber,
  return: AppFiber,
  ...
};

const MainFiber = {
  tag: HostComponent,
  child: SidebarFiber,
  sibling: FooterFiber,
  return: AppFiber,
  ...
};

const SidebarFiber = {
  tag: HostComponent,
  child: null,
  sibling: ContentFiber,
  return: MainFiber,
  ...
};

const ContentFiber = {
  tag: HostComponent,
  child: null,
  sibling: null,
  return: MainFiber,
  ...
};

const FooterFiber = {
  tag: HostComponent,
  child: null,
  sibling: null,
  return: AppFiber,
  ...
};
```

通过这种链表结构，React 能够高效地遍历和更新组件树，确保应用的高性能和响应性。

filber 中的 effect 做什么的？
ChatGPT
在 React Fiber 架构中，effect 是一个重要的概念，用于处理副作用（side effects）。副作用包括 DOM 操作、更新 refs、调用生命周期方法等。Fiber 树中的每个节点都有一个 effectTag 字段，用于标记该节点需要执行的副作用类型。此外，还有一个 firstEffect 和 nextEffect 字段，用于构建一个副作用链表。

Effect Tags
effectTag 是一个位字段（bitfield），用来描述需要在某个 Fiber 节点上执行的特定副作用类型。常见的副作用类型包括：

Placement：表示需要在 DOM 中新插入一个节点。
Update：表示需要更新现有的节点。
Deletion：表示需要从 DOM 中删除一个节点。
ContentReset：表示需要重置节点的内容。
Callback：表示需要执行回调函数。
Ref：表示需要更新 refs。
Effect 链表
Fiber 节点通过 firstEffect 和 nextEffect 字段形成一个链表，串联起所有需要执行副作用的节点。这个链表会在提交阶段遍历，以执行所有的副作用。

处理副作用的过程

1. 标记副作用
   在协调（Reconciliation）阶段，React 会在 Fiber 节点上设置适当的 effectTag，以标记需要执行的副作用。

```javascript
function completeWork(current, workInProgress, renderExpirationTime) {
  // ...其他逻辑

  if (workInProgress.effectTag !== NoEffect) {
    if (root.firstEffect === null) {
      root.firstEffect = workInProgress;
    } else {
      root.lastEffect.nextEffect = workInProgress;
    }
    root.lastEffect = workInProgress;
  }
}
```

1. 构建 Effect 链表
   在完成每个工作单元时，React 会将具有副作用的 Fiber 节点添加到 Effect 链表中。

```javascript
function completeUnitOfWork(unitOfWork) {
  let completedWork = unitOfWork;

  do {
    const returnFiber = completedWork.return;
    const siblingFiber = completedWork.sibling;

    // 处理完成的节点，例如附加副作用
    if (completedWork.effectTag !== NoEffect) {
      if (returnFiber.firstEffect === null) {
        returnFiber.firstEffect = completedWork.firstEffect;
      }
      if (completedWork.lastEffect !== null) {
        if (returnFiber.lastEffect !== null) {
          returnFiber.lastEffect.nextEffect = completedWork.firstEffect;
        }
        returnFiber.lastEffect = completedWork.lastEffect;
      }

      const effect = completedWork;
      if (returnFiber.lastEffect !== null) {
        returnFiber.lastEffect.nextEffect = effect;
      } else {
        returnFiber.firstEffect = effect;
      }
      returnFiber.lastEffect = effect;
    }

    if (siblingFiber !== null) {
      return siblingFiber;
    }

    completedWork = returnFiber;
  } while (completedWork !== null);
}
```

1. 提交副作用
   在提交（Commit）阶段，React 会遍历 Effect 链表，并根据 effectTag 执行相应的副作用。

```javascript
function commitRoot(root) {
  const firstEffect = root.firstEffect;
  if (firstEffect !== null) {
    let nextEffect = firstEffect;
    do {
      try {
        commitBeforeMutationEffects(nextEffect);
      } catch (error) {
        // 错误处理
      }
      nextEffect = nextEffect.nextEffect;
    } while (nextEffect !== null);

    nextEffect = firstEffect;
    do {
      try {
        commitMutationEffects(root, nextEffect);
      } catch (error) {
        // 错误处理
      }
      nextEffect = nextEffect.nextEffect;
    } while (nextEffect !== null);

    nextEffect = firstEffect;
    do {
      try {
        commitLayoutEffects(root, nextEffect);
      } catch (error) {
        // 错误处理
      }
      nextEffect = nextEffect.nextEffect;
    } while (nextEffect !== null);
  }

  // 重置 Effect 链表
  root.firstEffect = root.lastEffect = null;
}
```

小结
effectTag：用于标记 Fiber 节点需要执行的副作用类型。
Effect 链表：由 firstEffect 和 nextEffect 字段构建，用于在提交阶段遍历并执行副作用。
提交阶段：遍历 Effect 链表并根据 effectTag 执行相应的副作用，包括插入、更新、删除 DOM 节点，更新 refs，执行生命周期方法等。
通过这种机制，React 能够高效地管理和执行副作用，确保组件树的状态与实际 DOM 保持一致。

## 更新与提交阶段

React Fiber 架构将组件更新过程分为两个主要阶段：渲染阶段（Render Phase）和提交阶段（Commit Phase）。这两个阶段分别负责不同的任务，以确保更新过程的高效和流畅。

渲染阶段（Render Phase）
渲染阶段是指协调（Reconciliation）阶段，主要任务是计算和准备更新，这一过程是可中断的，可以分为多个任务片段在浏览器空闲时间执行。

关键点：
创建和更新 Fiber 树：在这个阶段，React 会遍历组件树，生成或更新对应的 Fiber 节点，构建新的 Fiber 树（工作进展树）。
计算变化：React 会比较新旧 Fiber 树，找出需要更新的部分，并在 Fiber 节点上打上标记（effect tags）。
可中断：渲染阶段是可中断的，React 可以在处理过程中暂停，以响应更高优先级的任务（如用户交互）。
副作用收集：在这个阶段，所有的副作用会被收集，并添加到 Effect 链表中，但不会立即执行。
关键函数：
beginWork：用于处理每个 Fiber 节点，生成新的 Fiber 树或更新现有树。
completeUnitOfWork：用于处理完成的工作单元，收集副作用并构建 Effect 链表。

```javascript
function beginWork(current, workInProgress, renderExpirationTime) {
  // 根据节点类型和状态处理 Fiber 节点
  // ...
  return next;
}

function completeUnitOfWork(unitOfWork) {
  // 处理完成的节点，并构建 Effect 链表
  // ...
  return next;
}
```

提交阶段（Commit Phase）
提交阶段是指将渲染阶段计算出的变化实际应用到 DOM 中的过程，这一过程是同步且不可中断的。

关键点：
DOM 更新：在提交阶段，React 会根据 Effect 链表中的副作用标记，执行相应的 DOM 更新操作。
不可中断：为了保证更新的一致性和完整性，提交阶段是同步执行的，不会被中断。
生命周期方法：在这一阶段，会调用组件的生命周期方法（如 componentDidMount、componentDidUpdate 等）。
清理工作：在完成所有副作用后，React 会清理副作用链表，准备下一个更新循环。
提交阶段的步骤：
Before Mutation Phase：在 DOM 变更前执行副作用，如 getSnapshotBeforeUpdate。
Mutation Phase：实际进行 DOM 变更，包括插入、更新、删除节点。
Layout Phase：在 DOM 变更后执行副作用，如调用 componentDidMount 和 componentDidUpdate。
关键函数：
commitBeforeMutationEffects：处理 DOM 变更前的副作用。
commitMutationEffects：处理实际的 DOM 变更。
commitLayoutEffects：处理 DOM 变更后的副作用。

```javascript
function commitRoot(root) {
  const firstEffect = root.firstEffect;

  // Before Mutation Phase
  let nextEffect = firstEffect;
  while (nextEffect !== null) {
    commitBeforeMutationEffects(nextEffect);
    nextEffect = nextEffect.nextEffect;
  }

  // Mutation Phase
  nextEffect = firstEffect;
  while (nextEffect !== null) {
    commitMutationEffects(root, nextEffect);
    nextEffect = nextEffect.nextEffect;
  }

  // Layout Phase
  nextEffect = firstEffect;
  while (nextEffect !== null) {
    commitLayoutEffects(root, nextEffect);
    nextEffect = nextEffect.nextEffect;
  }

  // 清理 Effect 链表
  root.firstEffect = root.lastEffect = null;
}
```

小结
渲染阶段（Render Phase）：负责计算和准备更新，构建新的 Fiber 树，可中断。

主要任务：创建和更新 Fiber 树、计算变化、收集副作用。
关键函数：beginWork、completeUnitOfWork。
提交阶段（Commit Phase）：负责将变化应用到 DOM 中，不可中断。

主要任务：执行 DOM 更新、调用生命周期方法、清理副作用。
关键函数：commitRoot、commitBeforeMutationEffects、commitMutationEffects、commitLayoutEffects。
通过这种分阶段的处理方式，React 能够高效地管理和调度组件更新，确保用户界面的高性能和响应性。
