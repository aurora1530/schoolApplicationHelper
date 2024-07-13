import { PrismaClient } from '@prisma/client';

export class Client extends PrismaClient {
  private static _instance: Client;

  private constructor() {
    super();
  }

  public static getInstance(): Client {
    if (!Client._instance) {
      Client._instance = new Client();
    }
    return Client._instance;
  }
}
