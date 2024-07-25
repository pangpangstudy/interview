在 NextAuth.js 中，providers 的作用是配置和管理不同的身份验证提供者（如 GitHub、Google、Facebook 等）。这些提供者允许用户通过他们的第三方账户登录你的应用。NextAuth.js 支持多种身份验证提供者，包括 OAuth 提供者、电子邮件登录以及自定义的身份验证提供者。

1. 配置 NextAuth.js

```js
// pages/api/auth/[...nextauth].js
import NextAuth from "next-auth";
import GitHubProvider from "next-auth/providers/github";
import GoogleProvider from "next-auth/providers/google";

export default NextAuth({
  providers: [
    GitHubProvider({
      clientId: process.env.GITHUB_ID,
      clientSecret: process.env.GITHUB_SECRET,
    }),
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
    // 添加更多提供者
  ],
  // 可选配置
  // database: process.env.DATABASE_URL, // 配置数据库连接
  // session: { jwt: true }, // 使用 JWT 代替数据库会话
  // callbacks: {
  //   async signIn(user, account, profile) { return true },
  //   async redirect(url, baseUrl) { return baseUrl },
  //   async session(session, user) { return session },
  //   async jwt(token, user, account, profile, isNewUser) { return token }
  // }
});
```

2.  获取提供者的凭证

```js
GITHUB_ID = your_github_client_id;
GITHUB_SECRET = your_github_client_secret;
GOOGLE_CLIENT_ID = your_google_client_id;
GOOGLE_CLIENT_SECRET = your_google_client_secret;
```

3. 使用提供者进行身份验证
   在你的 Next.js 应用中，你可以使用 signIn 和 signOut 方法来处理用户登录和退出。

```js
import { signIn, signOut, useSession } from "next-auth/react";

export default function Home() {
  const { data: session } = useSession();

  return (
    <div>
      {!session ? (
        <>
          <h1>Please sign in</h1>
          <button onClick={() => signIn("github")}>Sign in with GitHub</button>
          <button onClick={() => signIn("google")}>Sign in with Google</button>
        </>
      ) : (
        <>
          <h1>Welcome, {session.user.name}</h1>
          <button onClick={() => signOut()}>Sign out</button>
        </>
      )}
    </div>
  );
}
```
