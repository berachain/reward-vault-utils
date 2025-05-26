import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExampleService {
  constructor(private readonly prisma: PrismaService) {}

  async createMockData() {
    console.log('Creating mock data for button presses...');
    const addresses = Array.from({ length: 50 }, () => this.generateRandomAddress());
    const now = new Date();

    for (const address of addresses) {
      const pressCount = Math.floor(Math.random() * 100) + 1;
      let lastTimestamp = now;
      for (let i = 0; i < pressCount; i++) {
        const jitter = Math.floor(Math.random() * 3600000); // Random jitter up to 1 hour
        const timestamp = new Date(lastTimestamp.getTime() - 3600000 - jitter); // At least 1 hour apart
        await this.prisma.buttonPress.create({
          data: {
            address,
            timestamp,
          },
        });
        lastTimestamp = timestamp;
      }
    }
    console.log('Mock data creation completed.');
  }

  private generateRandomAddress(): string {
    return '0x' + Array.from({ length: 40 }, () => Math.floor(Math.random() * 16).toString(16)).join('');
  }
} 