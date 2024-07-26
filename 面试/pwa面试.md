pwa 步骤：
安装 next-pwa

### next-pwa 提供的功能

Service Worker 生成和注册
缓存
离线支持
manifest 文件生成
head 元标记

### pwa 配置

```mjs
import withPWA from "next-pwa";
/** @type { import('next').NextConfig } */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  compilation: {
    removeConsole: process.env.NODE_ENV !== "development",
  },
};
export default withPWA({
    dest:"public"//pwa的文件目录
    disable:process.env.NODE_ENV === "development",
    register:true,//注册pwa服务工作线程
    skipWaiting:true,//跳过等待服务工作线程激活
})(nextConfig)
```

此代码使用该包设置具有 PWA 功能的 Next.js 应用程序 next-pwa。它根据开发环境的最佳实践配置与 React 严格模式、最小化、服务工作线程行为和 PWA 注册相关的各种选项。
创建.env 文件并将其定义 NODE_ENV 为开发。然后使用此新代码
更新文件.gitignore

```js
**/public/sw.js
**/public/workbox-*.js
```

## 添加清单文件 manifest.json

辅助生成[https://www.mridul.tech/tools/manifest-generator]
示例：

```json
{
  "short_name": "Your Name",
  "name": "Your Name",
  "description": "Your description",
  "homepage_url": "https://pancakeswap.finance",
  // start_url 定义了当用户从设备上的主屏幕图标启动 PWA 时，加载的初始 URL。. 表示相对于 manifest.json 文件的位置，因此通常表示应用的根目录。可以设为具体页面路径，如 /index.html 或 /home，根据需要调整。
  "start_url": ".",
  // fullscreen：全屏显示，覆盖整个屏幕，不显示浏览器 UI。
  // standalone：独立显示，类似于本地应用，隐藏浏览器 UI，但保留系统状态栏。
  // minimal-ui：最小化的 UI，类似于 standalone，但带有最小的浏览器控件，如后退按钮。
  // browser：常规浏览器模式，显示完整的浏览器 UI。
  "display": "standalone",
  "theme_color": "#1FC7D4",
  "background_color": "#ffffff",
  "orientation": "portrait",
  "icons": [
    {
      "src": "favicon.ico",
      "type": "image/x-icon",
      "sizes": "16x16"
    },
    {
      "src": "logo.png",
      "type": "image/png",
      "sizes": "256x256"
    }
  ],
  "iconPath": "cake.svg"
}
```

## 定义 pwa 的元数据

在 layout.ts 文件中 配置 pwa 元数据

```js
import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  // .....

  manifest: "/manifest.json",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode,
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  );
}
```

确保将所有图标添加到“public/icons”中

### 构建

构建完成后 会生成两个文件
sw.js：此文件是 Service Worker 文件。Service Worker 可用于各种目的，例如缓存、后台同步、提供本机功能以及启用离线支持
workbox-07a7b4f2.js：此文件名为 workbox，用于方便资产缓存。它通过在本地存储常用资产来减少重复下载的需要，有助于提高 Web 应用程序的性能。
