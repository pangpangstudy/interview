Partial<T>：将类型 T 的所有属性变为可选。
Required<T>：将类型 T 的所有属性变为必需。
Readonly<T>
作用：将类型 T 的所有属性变为只读。
Pick<T, K>
作用：从类型 T 中选择一组属性 K 组成新的类型。
Omit<T, K>
作用：从类型 T 中排除一组属性 K，形成新的类型。
Record<K, T>
作用：构造一个类型，其属性键为 K，属性值为 T。
Exclude<T, U>
作用：从类型 T 中排除可以赋值给类型 U 的那些类型。
Extract<T, U>
作用：从类型 T 中提取可以赋值给类型 U 的那些类型。
NonNullable<T>
作用：从类型 T 中排除 null 和 undefined。
Parameters<T>
作用：获取函数类型 T 的参数类型组成的元组类型
ConstructorParameters<T>
作用：获取构造函数类型 T 的参数类型组成的元组类型。
ReturnType<T>
作用：获取函数类型 T 的返回值类型。
InstanceType<T>
作用：获取构造函数类型 T 的实例类型。
