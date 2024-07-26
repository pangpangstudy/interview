React Query 是一个用于在 React 应用中管理服务器状态的库。它简化了数据获取、缓存、同步和更新的流程。

## React Query 的核心概念是什么？

回答：React Query 的核心概念包括 Queries、Mutations、Query Keys、Query Functions、Caching 和 Background Sync。

## 什么是 Query Key？它在 React Query 中有什么作用？

回答：Query Key 是一个唯一标识符，用于标识查询。在 React Query 中，它用于区分不同的查询，以便进行缓存、刷新等操作。

## 如何在 React Query 中进行数据变更（例如：添加、更新或删除数据）？

```js
function MyComponent() {
  const queryClient = useQueryClient();
  const mutation = useMutation(addData, {
    onSuccess: () => {
      queryClient.invalidateQueries("fetchData");
    },
  });
}
```

## 如何在 React Query 中处理缓存过期？

回答：可以通过配置 staleTime 来控制缓存的过期时间。例如，设置数据在 5 分钟内不过期：

## 如何在 React Query 中处理错误？

回答：可以通过 onError 回调来处理错误：

```js
const { data, error, isError } = useQuery("fetchData", fetchData, {
  onError: (error) => {
    console.error("Error fetching data:", error);
  },
});

if (isError) return <div>Error: {error.message}</div>;
```

# 性能优化：

## 如何在 React Query 中实现数据预取（Prefetching）？

回答：可以使用 queryClient.prefetchQuery 方法在用户导航到页面之前预取数据：

```js
import { useQueryClient } from "@tanstack/react-query";

function MyComponent() {
  const queryClient = useQueryClient();

  useEffect(() => {
    queryClient.prefetchQuery("fetchData", fetchData);
  }, [queryClient]);

  return <div>Data is being prefetched</div>;
}
```

## 如何在 React Query 中处理分页数据？

回答：可以通过查询键和查询函数的组合来实现分页

```js
import { useQuery } from "@tanstack/react-query";

function fetchPaginatedData(page = 1) {
  return fetch(`https://api.example.com/data?page=${page}`).then((response) =>
    response.json()
  );
}

function MyComponent() {
  const [page, setPage] = useState(1);
  const { data, isLoading, error } = useQuery(["fetchData", page], () =>
    fetchPaginatedData(page)
  );

  if (isLoading) return "Loading...";
  if (error) return "An error occurred";

  return (
    <div>
      {data.map((item) => (
        <div key={item.id}>{item.name}</div>
      ))}
      <button onClick={() => setPage((prev) => prev + 1)}>Next Page</button>
    </div>
  );
}
```
