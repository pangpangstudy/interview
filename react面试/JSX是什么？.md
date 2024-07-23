JSX 是一个 react 语法糖，，可以直接在 html 中写 js，需要 babel webpack 进行编译成 js 给浏览器执行

与 js 的区别

jsx 需要编译，jsx 是 React.createElement 语法糖

为什么需要再文件顶部引入 react？
因为 jsx 是 react 语法糖，需要 React.createElement

为什么 react 组件首字母需要大写？

在 React 中，组件的首字母需要大写是因为这是 React 用来区分组件和 HTML 元素的关键机制之一。这种约定使得 React 能够正确地解析和渲染组件。以下是详细的原因和解释：

1. 区分 React 组件和 HTML 元素
   React 使用 JSX 语法来定义组件和元素。为了区分自定义组件和原生 HTML 元素，React 规定组件名称必须以大写字母开头。

原生 HTML 元素：以小写字母开头，例如 <div>, <span>, <button> 等。
自定义 React 组件：以大写字母开头，例如 <MyComponent>, <Header>, <App> 等。

```jsx
// 自定义组件
function MyComponent() {
  return <div>Hello, World!</div>;
}

// 使用自定义组件
<MyComponent />

// 使用原生 HTML 元素
<div>Hello, World!</div>
```

2. JSX 转换机制
   在 JSX 中，React 使用 Babel 等工具将 JSX 语法转换为 JavaScript 函数调用。以大写字母开头的标签会被转换为组件函数调用，而以小写字母开头的标签会被转换为字符串（表示 HTML 元素）。

```jsx
// JSX 语法
<MyComponent />
<div />

// 转换后的 JavaScript 代码
React.createElement(MyComponent);
React.createElement('div');

```

react 组件为什么不能返回多个元素？

在 React 的早期版本中，组件不能直接返回多个元素。这是因为 JSX 必须有一个根元素来封装所有的子元素。这个限制源于 HTML 和 JSX 的语法要求，它们都需要有一个根节点来表示一个有效的树结构。然而，这种限制在后来的 React 版本中得到了改进

如何返回多个组件？

1. HOC
2. Fragment：使用 React.Fragment 或简写语法 <>...</> 来返回多个子元素而不引入额外的 DOM 节点。
3. 数组：返回一个包含多个子元素的数组，并为每个子元素添加唯一的 key 属性。
