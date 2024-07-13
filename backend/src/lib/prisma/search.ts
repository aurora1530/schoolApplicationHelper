import { Client } from "./prisma"

export const searchSchoolsByName = async (nameQuery: string) => {
  const client = Client.getInstance()

  console.log(nameQuery)
  const schools = await client.highSchool.findMany({
    where: {
      name: {
        contains: nameQuery
      }
    }
  })

  return schools
}