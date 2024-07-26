withIntl

```js
import createMiddleware from "next-intl/middleware";
import { MiddlewareFactory } from "./types";
import { locales } from "@/navigation";
import { NextResponse } from "next/server";
const nextIntlMiddleware = createMiddleware({
  locales,
  defaultLocale: "en",
  localePrefix: "never",
});
export const NextIntlMiddleware: MiddlewareFactory = (next) => {
  return async (request, event) => {
    const response = nextIntlMiddleware(request) || NextResponse.next();
    if (response) {
      return response;
    }
    return next(request, event);
  };
};
```

message

[local] 动态路由

i18n.ts 文件

```js
import createMiddleware from "next-intl/middleware";
import { MiddlewareFactory } from "./types";
import { locales } from "@/navigation";
import { NextResponse } from "next/server";
const nextIntlMiddleware = createMiddleware({
  locales,
  defaultLocale: "en",
  localePrefix: "never",
});
export const NextIntlMiddleware: MiddlewareFactory = (next) => {
  return async (request, event) => {
    const response = nextIntlMiddleware(request) || NextResponse.next();
    if (response) {
      return response;
    }
    return next(request, event);
  };
};
```
