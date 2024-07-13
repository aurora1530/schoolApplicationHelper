import { Prisma } from '@prisma/client';
import { Client } from './prisma';
import { hiraganaToKatakana } from './utils';

type SchoolInfo = {
  id: number;
  name: string;
  prefecture: string;
};

export const searchSchoolsByName = async (
  nameQuery: string,
  page: number = 1
): Promise<{
  items: SchoolInfo[];
  count: number;
  pageCount: number;
}> => {
  const perPage = 20;
  const skip = perPage * (page - 1);
  const where: Prisma.HighSchoolScalarWhereInput = {
    name: {
      contains: nameQuery,
    },
  };

  const client = Client.getInstance();

  nameQuery = hiraganaToKatakana(nameQuery);
  const [schools, schoolsCount] = await Promise.all([
    client.highSchool.findMany({
      where,
      orderBy: {
        name: 'asc',
      },
      skip,
      take: perPage,
      select: {
        id: true,
        name: true,
        prefecture: true,
      },
    }),
    client.highSchool.count({ where }),
  ]);

  const pageCount = Math.ceil(schoolsCount / perPage);

  const items = schools.map((school) => ({
    id: school.id,
    name: school.name,
    prefecture: school.prefecture.name,
  }));

  return {
    items,
    count: schoolsCount,
    pageCount,
  };
};
