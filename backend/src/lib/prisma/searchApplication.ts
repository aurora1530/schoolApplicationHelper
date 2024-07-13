import { Client } from './prisma';

type ApplicationInfo = {
  id: number;
  deadline: Date;
  highSchoolName: string;
  method: string;
  subjects: string;
  documents: string;
};

export const searchApplicationBySchoolId = async (
  schoolId: number
): Promise<ApplicationInfo[]> => {
  const client = Client.getInstance();

  const applications = await client.application.findMany({
    where: {
      highSchoolID: schoolId,
    },
    select: {
      id: true,
      deadline: true,
      highSchool: {
        select: {
          name: true,
        },
      },
      method: true,
      subjects: true,
      documents: true,
    },
  });

  return applications.map((application) => ({
    id: application.id,
    deadline: application.deadline,
    highSchoolName: application.highSchool.name,
    method: application.method,
    subjects: application.subjects,
    documents: application.documents,
  }));
};
