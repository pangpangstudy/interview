React 18 引入了许多新的特性和改进，旨在提升性能、优化开发体验以及增强用户界面的交互性。以下是 React 18 的一些主要更新和新特性：

1. 并发特性（Concurrent Features）
   a. 自动批处理（Automatic Batching）
   React 18 引入了自动批处理特性，允许在一个事件循环中自动批处理多个状态更新，从而减少重新渲染的次数。

```javascript
function handleClick() {
  setState1((prev) => prev + 1);
  setState2((prev) => prev + 1);
  // 在 React 18 中，这两个状态更新会被自动批处理
}
```

b. startTransition API
startTransition 允许你标记更新为“过渡”更新，从而优先处理紧急更新（如用户输入），并在后台处理非紧急更新（如页面内容加载）。

```javascript
import { startTransition } from "react";

function handleInputChange(event) {
  startTransition(() => {
    setSearchQuery(event.target.value);
  });
}
```

c. useTransition Hook
useTransition 是一个新的 Hook，用于管理过渡状态，包括提供一个布尔值来指示过渡是否正在进行。

```javascript
const [isPending, startTransition] = useTransition();

function handleClick() {
  startTransition(() => {
    setState((prev) => prev + 1);
  });
}
```

1. Suspense 改进
   a. SSR 支持
   React 18 进一步增强了对 Suspense 的支持，特别是在服务器端渲染（SSR）中的使用，使得服务器端渲染更高效。

```jsx
<Suspense fallback={<Loading />}>
  <SomeComponent />
</Suspense>
```

1. React Server Components
   React Server Components 是一种新的架构模式，允许部分组件在服务器上渲染，并将结果发送到客户端。这种方式可以显著减少客户端的 JavaScript 负载，提高性能。

1. 新的 Hook
   a. useDeferredValue
   useDeferredValue 用于推迟更新，减少高优先级状态变化对低优先级状态变化的影响。

`const deferredValue = useDeferredValue(value);`
b. useId
useId 用于生成唯一的 ID，通常用于表单元素等需要唯一标识符的地方。

`const id = useId();`

1. 新的 root API
   a. createRoot
   React 18 引入了新的 createRoot API，替代以前的 ReactDOM.render，以便更好地支持并发特性。

```javascript
import { createRoot } from "react-dom/client";

const root = createRoot(document.getElementById("root"));
root.render(<App />);
```

1. 服务端渲染的改进
   React 18 引入了一些服务器端渲染的改进，使得 React 应用的初始加载更快。

1. 不再默认启用 Strict Mode 的双渲染
   在 React 18 中，严格模式下的双渲染（Double Invoking Effects）不会默认启用，只在开发模式中有效。

小结
React 18 引入了许多重要的改进和新特性，特别是并发特性和新的 Hook，这些更新旨在提高应用性能和开发体验。以下是 React 18 的主要更新点总结：

并发特性：自动批处理、startTransition API、useTransition Hook。
Suspense 改进：更好的 SSR 支持。
React Server Components：服务器端组件渲染。
新的 Hook：useDeferredValue 和 useId。
新的 root API：createRoot。
服务端渲染的改进。
严格模式的双渲染仅在开发模式启用。
这些更新使得 React 在处理复杂交互和性能优化方面变得更加强大和高效。

## 对比说明

React 17 和 React 18 的主要区别

1. 并发特性（Concurrent Features）
   React 17：

不支持并发特性，更新是同步进行的。
React 18：

引入并发特性，允许在后台处理非紧急更新，提高应用响应性。
自动批处理（Automatic Batching）：不仅在事件处理函数中进行批处理，在异步代码中也会自动批处理。
startTransition API：允许开发者将更新标记为“过渡”，以便 React 能够优先处理更紧急的更新。
useTransition Hook：用于管理过渡状态，包括提供一个布尔值来指示过渡是否正在进行。

2.  Suspense 改进
    React 17：

支持 Suspense，但在服务器端渲染（SSR）中支持有限。
React 18：

SSR 支持：增强了对 Suspense 的支持，特别是在服务器端渲染中的使用，使得服务器端渲染更高效。

3. React Server Components
   React 17：

不支持 React Server Components。
React 18：

引入 React Server Components，允许部分组件在服务器上渲染，并将结果发送到客户端。这种方式可以显著减少客户端的 JavaScript 负载，提高性能。

4. 新的 Hook
   React 17：

提供了一些基本的 Hook（如 useState, useEffect, useContext 等）。
React 18：

useDeferredValue：用于推迟更新，减少高优先级状态变化对低优先级状态变化的影响。
useId：用于生成唯一的 ID，通常用于表单元素等需要唯一标识符的地方。

5.  新的 root API
    React 17：

使用 ReactDOM.render 来渲染应用。
React 18：

引入了新的 createRoot API，替代 ReactDOM.render，以便更好地支持并发特性。
// React 17
import ReactDOM from 'react-dom';
ReactDOM.render(<App />, document.getElementById('root'));

// React 18
import { createRoot } from 'react-dom/client';
const root = createRoot(document.getElementById('root'));
root.render(<App />);

6. 服务端渲染的改进
   React 17：

提供基本的服务器端渲染支持。
React 18：

引入了一些服务器端渲染的改进，使得 React 应用的初始加载更快。

7.  严格模式下的双渲染
    React 17：

在严格模式（Strict Mode）下，不会双渲染组件。
React 18：

在开发模式下，严格模式（Strict Mode）下会双渲染组件，以帮助开发者发现副作用。

8.  useInsertionEffect 执行实际：dom 生成之后
9.  concurrent mode
    同步不可中断 变成异步可中断
