## 解决了什么问题？

react 16.8 class 组件 function 组件

区别：

- 类组件需要生命 constructor 函数组件不需要
- 类组件需要手动绑定 this 函数组件 不需要
- 类组件需要函数生命周期狗子 函数组件没有
- 类组件需要自己维护自己的 this.state 函数：无状态
- 类组件 需要继承 class 函数不需要
- 类组件 面向对象 封装很多属性很方法 麻烦 函数：函数式变成思想

## 为什么需要 Hook

- 告别难以理解的 class 组件
- 解决业务组件难以拆分的问题
- 是状态逻辑复用变得简单
- 设计理念 更适合 react

## 局限

- hook 不能完整的提供类组件的能力
- 对开发者提出更高要求
- hooks 在使用层面有规则约束

# hook

useEffect 生命周期 hook
useMemo 缓存函数执行结果
useState

# 实现细节

在实际的 React 实现中，管理 Hooks 状态和上下文是通过 Fiber 架构完成的。以下是一些关键概念：

Fiber：
Fiber 是 React 用来管理组件树的单元。每个 Fiber 对象表示组件树中的一个节点，包含了组件的状态、更新队列等信息。

Hook 链表：
每个 Fiber 对象都有一个 Hook 链表，用于存储组件的所有 Hook 状态。每次渲染时，React 会遍历这个链表来读取和更新 Hook 状态。

全局指针：
在函数组件渲染期间，React 使用全局指针（如 currentHook）来指向当前处理的 Hook。每次调用 Hook 时，这个指针会递增，以确保按顺序处理每个 Hook。
