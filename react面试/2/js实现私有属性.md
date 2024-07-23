在 JavaScript 中实现私有属性可以通过多种方式完成，包括使用闭包和 ES6 的 WeakMap 以及 ES2020 引入的私有字段（Private Fields）特性。下面我们分别介绍这些方法。

## 使用闭包实现私有属性

闭包是一种常见的实现私有属性的方法，通过将变量保存在函数作用域内，使其无法从外部访问。

```js
function Person(name) {
  let _name = name; // 私有属性

  this.getName = function () {
    return _name;
  };

  this.setName = function (newName) {
    _name = newName;
  };
}

const person = new Person("Alice");
console.log(person.getName()); // 输出: Alice
person.setName("Bob");
console.log(person.getName()); // 输出: Bob
console.log(person._name); // 输出: undefined
```

## 使用 WeakMap 实现私有属性

WeakMap 可以用于存储私有属性，因为它的键是对象，值是任意类型，并且键值对是弱引用，不会影响垃圾回收。

```js
const _name = new WeakMap();

class Person {
  constructor(name) {
    _name.set(this, name); // 私有属性
  }

  getName() {
    return _name.get(this);
  }

  setName(newName) {
    _name.set(this, newName);
  }
}

const person = new Person("Alice");
console.log(person.getName()); // 输出: Alice
person.setName("Bob");
console.log(person.getName()); // 输出: Bob
console.log(_name.get(person)); // 输出: Bob（通过 WeakMap 访问，但外部无法直接访问 _name）
```

## 使用 ES2020 的私有字段

ES2020 引入了私有字段语法，使用 # 前缀定义私有属性，这些属性只能在类的内部访问。

```js
class Person {
  #name; // 私有属性

  constructor(name) {
    this.#name = name;
  }

  getName() {
    return this.#name;
  }

  setName(newName) {
    this.#name = newName;
  }
}

const person = new Person("Alice");
console.log(person.getName()); // 输出: Alice
person.setName("Bob");
console.log(person.getName()); // 输出: Bob
console.log(person.#name); // 抛出 SyntaxError: Private field '#name' must be declared in an enclosing class
```

React 中可以通过 useState 钩子实现响应式的私有属性：
