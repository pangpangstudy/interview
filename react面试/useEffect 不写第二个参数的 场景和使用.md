在 React 中，useEffect 是一个强大的 Hook，用于处理副作用（如数据获取、订阅、DOM 操作等）。useEffect 的第二个参数是一个依赖数组，用于控制副作用的执行时机。如果不提供第二个参数，useEffect 会在每次组件渲染后都执行。这种用法有其特定的应用场景和注意事项。

## 不写第二个参数的场景和使用

1. 需要在每次渲染后执行的副作用
   例如日志记录、更新某些状态或者执行某些全局操作。

```jsx
import React, { useState, useEffect } from "react";

function LoggerComponent() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log(`Component rendered. Current count: ${count}`);
  });

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

export default LoggerComponent;
```

在这个示例中，每次 LoggerComponent 渲染时，都会执行 useEffect 中的日志记录操作。

2.  依赖于不断变化的状态
    有些副作用需要在每次组件更新时都执行，以确保与组件的最新状态保持同步。例如，动态更新某些非 React 管理的全局变量或外部系统状态。
3.  无法确定依赖项的场景
    在某些复杂的场景中，可能难以确定所有的依赖项。这时，不提供第二个参数可以确保副作用在每次渲染时都执行。
    示例：复杂计算

## 实际应用场景示例：使用 useEffect 不写第二个参数

1. 实时日志记录和监控
   在开发过程中，实时日志记录可以帮助开发者监控组件的行为和状态变化，尤其是在调试复杂交互时。通过在 useEffect 中记录日志，可以在每次组件渲染后获取最新状态信息。

```jsx
import React, { useState, useEffect } from "react";

function LoggerComponent() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log(`Component rendered. Current count: ${count}`);
  });

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

export default LoggerComponent;
```

2. 动态更新全局状态或外部系统状态
   某些应用需要同步更新非 React 管理的全局变量或外部系统状态。在这些情况下，使用 useEffect 可以确保每次渲染时都能及时同步数据。

```jsx
import React, { useState, useEffect } from "react";

let globalVariable = 0;

function SyncComponent() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    globalVariable = count;
  });

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
      <p>Global variable: {globalVariable}</p>
    </div>
  );
}

export default SyncComponent;
```

3. 动态调整页面标题
   在某些应用中，你可能需要根据组件的状态动态调整页面标题。通过在 useEffect 中调用 document.title，可以在每次渲染时更新页面标题。

```jsx
import React, { useState, useEffect } from "react";

function TitleComponent() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    document.title = `Count: ${count}`;
  });

  return (
    <div>
      <p>{count}</p>
      <button onClick={() => setCount(count + 1)}>Increment</button>
    </div>
  );
}

export default TitleComponent;
```

4. 订阅事件和清理
   在组件中，你可能需要订阅一些全局事件（如窗口大小变化）并在组件卸载时取消订阅。使用 useEffect 可以确保在每次渲染时重新订阅事件，并在组件卸载时清理这些订阅。

```jsx
import React, { useState, useEffect } from "react";

function WindowResizeComponent() {
  const [windowWidth, setWindowWidth] = useState(window.innerWidth);

  useEffect(() => {
    const handleResize = () => {
      setWindowWidth(window.innerWidth);
    };

    window.addEventListener("resize", handleResize);

    // 清理函数
    return () => {
      window.removeEventListener("resize", handleResize);
    };
  });

  return <div>Window width: {windowWidth}px</div>;
}

export default WindowResizeComponent;
```
