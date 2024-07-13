import { Client } from "./prisma"

type SchoolInfo = {
  id: number
  name: string
  prefecture: string
}

export const searchSchoolsByName = async (nameQuery: string):Promise<SchoolInfo[]> => {
  const client = Client.getInstance()

  const schools = await client.highSchool.findMany({
    where: {
      name: {
        contains: nameQuery
      }
    },
    select: {
      id: true,
      name: true,
      prefecture: true
    }
  })

  return schools.map((school) => ({
    id: school.id,
    name: school.name,
    prefecture: school.prefecture.name
  }))
}