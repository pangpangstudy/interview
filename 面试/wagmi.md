```js

  return (
    <RainbowKitAuthenticationProvider adapter={authAdapter} status={authStatus}>
      <RainbowKitProvider locale="en-US">{children}</RainbowKitProvider>
    </RainbowKitAuthenticationProvider>
  );
};
export function ContextProvider({
  children,
  cookie,
}: {
  children: ReactNode;
  cookie?: string | null;
}) {
  const initialState = cookieToInitialState(config, cookie);
  return (
    <WagmiProvider config={config} initialState={initialState}>
      <QueryClientProvider client={queryClient}>
        <AuthProvider>{children}</AuthProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}
```

```js
export const config = createConfig({
  chains: supportChains,
  connectors,
  ssr: true,
  storage: createStorage({
    storage: cookieStorage,
  }),
  transports: {
    [bscTestnet.id]: http(),
  },
});
```
