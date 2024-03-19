// pages/api/auth/[...nextauth].js
import NextAuth from 'next-auth'
import Providers from 'next-auth/providers'
import { TypeOrmAdapter } from "@next-auth/typeorm-legacy-adapter";

export default NextAuth({
  providers: [
    Providers.Google({
      clientId: process.env.GOOGLE_ID,
      clientSecret: process.env.GOOGLE_SECRET,
    }),
    // Sie können hier weitere Anbieter hinzufügen
  ],
  adapter: TypeOrmAdapter.createAdapter({
    type: "mysql",
    host: process.env.DATABASE_HOST,
    port: process.env.DATABASE_PORT,
    username: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_NAME,
    synchronize: true,
  }),
  // Weitere Konfigurationsoptionen...
})