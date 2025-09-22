import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AnalyticsModule } from './analytics/analytics.module';


@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'db',
      port: Number(process.env.DB_PORT || 5432),
      username: process.env.DB_USERNAME || 'uni',
      password: process.env.DB_PASSWORD || 'uni',
      database: process.env.DB_DATABASE || 'universidade',
      autoLoadEntities: true,
      synchronize: process.env.NODE_ENV === 'development'
    }),
    AnalyticsModule
  ]
})
export class AppModule {}
