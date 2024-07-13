import { Client } from './prisma';

type ApplicationInfo = {
  id: number;
  deadline: Date;
  highSchoolName: string;
  method: string;
  subject: string;
  document: string;
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
      subject: true,
      document: true,
    },
  });

  return applications.map((application) => (
    {
      id: application.id,
      deadline: application.deadline,
      highSchoolName: application.highSchool.name,
      method: application.method,
      subject: application.subject,
      document: application.document,
    }
  ));
};
