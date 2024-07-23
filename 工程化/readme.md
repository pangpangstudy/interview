# 工程化

## 什么是工程化，做过哪些与工程化相关的事情？

概念：
以一种偏自动化、校本化的方法，结合一些工具解决一些纯人工处理的地晓得、非标准的问题、提升效率质量性能

## 什么是 AST

AST：抽象语法书，前端基建和工程化的基础，，一般会用一些工具，来对一些代码进行转义。

### 涉及工具

- webpack：可以拿到整个工程的 AST，使用 plugin 和 loader 进行注入
- babel：babel-plugin，能转移更多的 js 语法
- postcss：能够处理一些 css 的 prefixer，以及一些原子化 css 的能力

### AST 的概念

- 抽象语法书
- 给 es6、ts 这些语法，转义成一个描述语言内容的树形语法结构

### babel 正在前端中的作用

1. 代码的转义
   1. esnext->@babel/preset-env
   1. async await 装饰器
   1. ts->@babel/preset-typescript | tsc | ts-loader
      浏览器只能识别 js
   1. flow
2. 一些特定用途的代码转化
   1. taro 转义成小程序，babel 的 API 来实现
   2. react jsx -> React.createElement | jsx ->@babel/preset-react
3. 代码的静态分析工具
   1. linter 的工具
   2. jest 的工具

### babel 的主要工作流程是什么？

- parser：把源码转成 AST
  @babel/parser
- transform:便利 AST，，对 AST 进行必要的改造
  - @babel/traverse
  - 遍历 AST，最后调用 visitor 修改 AST
