import { Controller, OnApplicationBootstrap } from '@nestjs/common';
import { ExampleService } from './example.service';

@Controller()
export class ExampleController implements OnApplicationBootstrap {
  constructor(private readonly exampleService: ExampleService) {}

  async onApplicationBootstrap() {
    await this.exampleService.createMockData();
  }
} 