# hooks

hooks 与组件封装不同，hooks 大多是封装状态。

## useRequest 基础使用

请求并行,异步操作的状态封装

```js
const fetch1 = (): Promise<number> => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(1);
    }, 500);
  });
};
const fetch2 = (): Promise<number> => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(1);
    }, 500);
  });
};
const { data, error, loading } = useRequest(
  () => new Promise.all([fetch1, fetch2])
);
```

### 手动触发 options

比如表单的提交，特定时机才需要触发

```js
import { message } from "antd";
import React, { useState } from "react";
import { useRequest } from "ahooks";
function changeUsername(userName: string): Promise<{ success: boolean }> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve({ success: true });
    }, 1000);
  });
}
export default () => {
  const [state, setState] = useState("");

  const { loading, run } = useRequest(changeUsername, {
    manual: true,
    onSuccess: (result, params) => {
      if (result.success) {
        setState("");
        message.success(`The username was changed to "${params[0]}" !`);
      }
    },
  });
  return (
    <div>
      <input
        onChange={(e) => {
          setState(e.target.value);
        }}
        value={state}
      />
      <button
        disable={loading}
        onClick={() => {
          run(state);
        }}
      >
        {loading ? "loading..." : "Edit"}
      </button>
    </div>
  );
};
```

#### run & runAsync

对于手动触发 有两个执行函数，run 会自动捕获异常，通过 options.onError 获取异常信息
而 runAsync 需要自己捕获异常

```js
const { loading, run, runAsync } = useRequest(editUsername, {
  manual: true,
  onSuccess: (result, params) => {
    setState("");
    message.success(`The username was changed to "${params[0]}" !`);
  },
  onError: (e) => console.log(e),
});
const { loading, runAsync } = useRequest(editUsername, {
  manual: true,
});
const handleCLick = async () => {
  try {
    await runAsync(state);
    setState("");
    message.success(`The username was changed to "${state}" !`);
  } catch (e) {
    message.error(error.message);
  }
};
```

### 生命周期：onSuccess、onError、onBefore、onFinally

### refresh（使用上次的参数重新发出一次请求）

使用场景：比如一下 table 场景，刷新就需要重新获取数据，但是参数不变，就是用 refresh

```js
const { data, loading, run, refresh } = useRequest(
  (id: number) => getUsername(id),
  {
    manual: true,
  }
);
useEffect(() => {
  run(1);
}, []);

if (loading) {
  return <div>loading...</div>;
}
return (
  <div>
    <p>Username: {data}</p>
    <button onClick={refresh} type="button">
      Refresh
    </button>
  </div>
);
```

### 立即变更数据（不等待数据返回，直接修改 useRequest 返回的 dada）

使用场景：当我们不希望等编辑接口调用成功之后，才给用户反馈。而是直接修改页面数据，同时在背后去调用修改接口，等修改接口返回之后，另外提供反馈。

```js
import { message } from "antd";
import React, { useState, useRef } from "react";
import { useRequest } from "ahooks";
import Mock from "mockjs";

function getUsername(): Promise<string> {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(Mock.mock("@name"));
    }, 1000);
  });
}

function editUsername(username: string): Promise<void> {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      if (Math.random() > 0.5) {
        resolve();
      } else {
        reject(new Error("Failed to modify username"));
      }
    }, 1000);
  });
}

export default () => {
  const [state, setState] = useState("");
  const lastRef = useRef<string>();
//   当前用户名
  const { data: username, mutate } = useRequest(getUsername);
  const {
    run: edit,
  } = useRequest(editUsername, {
    manual: true,
    onSuccess: (result, params) => {
      setState("");
      message.success(`The username was changed to "${params[0]}" !`);
    },
    //即使发生错误，也能显示出
    onError:(error)=>{
        message.error(error.message)
        mutate(lastRef.current)
    }
  });
  const onChange = () => {
    lastRef.current = username
    mutate(state)
    edit(state)
  };
  return (
    <div>
      // 立即改变数据
      <p>Username:{}</p>
      <input
        onChange={(e) => setState(e.target.value)}
        value={state}
        placeholder="Please enter username"
        style={{ width: 240, marginRight: 16 }}
      />
      <button type="button" onClick={edit}>
        Edit
      </button>
    </div>
  );
};
```

### 取消获取当前 promise 返回的数据和错误

cancel

### 基础 API

```js
const {
  loading: boolean,
  data?: TData,
  error?: Error,
  params: TParams || [],
  run: (...params: TParams) => void,
  runAsync: (...params: TParams) => Promise<TData>,
  refresh: () => void,
  refreshAsync: () => Promise<TData>,
  mutate: (data?: TData | ((oldData?: TData) => (TData | undefined))) => void,
  cancel: () => void,
} = useRequest<TData, TParams>(
  service: (...args: TParams) => Promise<TData>,
  {
    manual?: boolean,
    defaultParams?: TParams,
    onBefore?: (params: TParams) => void,
    onSuccess?: (data: TData, params: TParams) => void,
    onError?: (e: Error, params: TParams) => void,
    onFinally?: (params: TParams, data?: TData, e?: Error) => void,
  }
);
```

### loading 延迟时间

```js
const { loading, data } = useRequest(getUsername, {
  loadingDelay: 300,
});

return <div>{loading ? "Loading..." : data}</div>;
```

### 轮询 pollingInterval

```js
import { useRequest } from "ahooks";
import React from "react";
import Mock from "mockjs";

function getUsername() {
  console.log("polling getUsername");
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(Mock.mock("@name"));
    }, 1000);
  });
}

export default () => {
  const { data, loading, error, cancel, run } = useRequest(getUsername, {
    pollingInterval: 1000,
    // 在页面隐藏时，是否继续轮询。如果设置为 false，在页面隐藏时会暂时停止轮询，页面重新显示时继续上次轮询。
    // manual = true,
    pollingWhenHidden: false,
    poolingErrorRetryCount: 3,
  });
  return (
    <>
      <p>Username: {loading ? "Loading" : data}</p>
      <button type="button" onClick={run}>
        start
      </button>
      <button type="button" onClick={cancel} style={{ marginLeft: 16 }}>
        stop
      </button>
    </>
  );
};
```

### 根据依赖进行 refresh

```js
const [userId, setUserId] = useState("1");
const { data, run } = useRequest(() => getUserSchool(userId), {
  refreshDeps: [userId],
});
//refreshDepsAction自定义依赖数组变化时的请求行为。
const { data, loading, run } = useRequest((id: number) => getUsername(id), {
  refreshDeps: [userId],
  refreshDepsAction: () => {
    if (!isNumber(userId)) {
      console.log(
        `parameter "userId" expected to be a number, but got ${typeof userId}.`,
        userId
      );
      return;
    }
    run(userId);
  },
});
```

### 屏幕聚焦重新请求

```js
const { data } = useRequest(getUsername, {
  refreshOnWindowFocus: true,
  //   设置重新请求间隔 默认：5000
  focusTimespan：1000
});
```

### 防抖 & 节流

```js
const { data, run } = useRequest(getUsername, {
  manual: true,
  debounceWait: 300,
});
const { data, run } = useRequest(getUsername, {
  throttleWait: 3000,
  manual: true,
});
```

### 缓存 & SWR

封装状态
存储介质、存储日期
如何保证缓存 又保证实时性（时间间隔重新请求、覆盖缓存）
先用 缓存进行展示、背后依然惊醒请求、当数据有变化、进行 state 更新

### 错误重试

```js
const { data, run } = useRequest(getUsername, {
  retryCount: 3,
  retryInterval: 2000,
});
```
