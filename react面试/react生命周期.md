# 生命周期

函数式是没有生命周期的（提供了生命周期 Hook），只有类组件才有

## 挂载

constructor 初始化阶段
static getDeriveStateFormProps
render 创建虚拟 DOM 阶段
componentDidMount 挂载到页面生成真实 DOM

## 更新

state props 发生变化 触发更新
static getDeriveStateFormProps
shouldComponentUpdate 性能优化
getSnapshotBeforeUpdate 获取更新前的状态
ComponentDidUpdate 完成更新后调用

## 卸载

ComponentWillUnmount 组件被移除时调用
