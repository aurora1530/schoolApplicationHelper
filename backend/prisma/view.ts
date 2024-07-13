import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const main = async () => {
  const prefectures = await prisma.prefecture.findMany();
  console.log(prefectures);

  const highSchools = await prisma.highSchool.findMany();
  console.log(highSchools);

  const applications = await prisma.application.findMany();
  console.log(applications);
};

main()
  .catch((e) => {
    throw e;
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
