import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  try {
    const app = await NestFactory.create(AppModule, {
      logger: ['error', 'warn', 'log', 'debug', 'verbose'],
    });

    // Configure Swagger
    const config = new DocumentBuilder()
      .setTitle('Reward Vault Indexer API')
      .setDescription('API documentation for the Reward Vault Indexer service')
      .setVersion('1.0')
      .addTag('allocations', 'Reward allocation endpoints')
      .addTag('merkle', 'Merkle tree management endpoints')
      .addTag('claims', 'Reward claim endpoints')
      .build();

    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup('api', app, document);

    await app.listen(3000);
    logger.log('Application is running on: http://localhost:3000');
  } catch (error) {
    logger.error('Error starting application:', error);
    process.exit(1);
  }
}
bootstrap(); 