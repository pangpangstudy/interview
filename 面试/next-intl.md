withIntl
nextIntlMiddleware
i18n.ts ：getRequestConfig

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
"server-only";
import { notFound } from "next/navigation";
import { getRequestConfig } from "next-intl/server";
import { locales } from "./navigation";
import defaultMessages from "../messages/en.json";

export default getRequestConfig(async ({ locale }) => {
  if (!locales.includes(locale as any)) notFound();
  const localMessage = (await import(`../messages/${locale}.json`)).default;
  const messages = { ...defaultMessages, ...localMessage };
  return {
    messages,
    formats: {
      dateTime: {
        medium: {
          dateStyle: "medium",
          timeStyle: "short",
          hour12: false,
        },
      },
    },
    onError(error) {
      if (
        error.message ===
        (process.env.NODE_ENV === "production"
          ? "MISSING_MESSAGE"
          : "MISSING_MESSAGE: Could not resolve `missing` in `Index`.")
      ) {
        // Do nothing, this error is triggered on purpose
      } else {
        console.error(JSON.stringify(error.message));
      }
    },
    // 消息回退函数，用于在消息缺失时提供回退消息
    getMessageFallback({ key, namespace }) {
      return (
        "`getMessageFallback` called for " +
        [namespace, key].filter((part) => part != null).join(".")
      );
    },
  };
});
```

```js
import { LocalePrefix } from "./types";
import {
  Pathnames,
  createLocalizedPathnamesNavigation,
} from "next-intl/navigation";
export const locales = ["en", "zh"] as const;
export type Locale = (typeof locales)[number];
export const defaultLocale = "en";
export const localePrefix = process.env
  .NEXT_PUBLIC_LOCALE_PREFIX as LocalePrefix;
export const pathnames = {
  "/": "/",
  "/example": {
    en: "/example",
    zh: "/example2",
  },
} satisfies Pathnames<typeof locales>;
export const { Link, redirect, usePathname, useRouter } =
  createLocalizedPathnamesNavigation({
    locales,
    localePrefix,
    pathnames,
  });
```
