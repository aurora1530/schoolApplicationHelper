import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { searchSchoolsByName } from './lib/prisma/searchHighSchool'
import { searchApplicationBySchoolId } from './lib/prisma/searchApplication'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/search/highSchools', async (c) => {
  const query = c.req.query('q') ?? ''
  if (!query) {
    c.status(400)
    return c.json({  error: 'Query is required' })
  }

  const schools = await searchSchoolsByName(query)

  return c.json(schools)
})

app.get('/search/highSchools/:id', async (c) => {
  const idStr = c.req.param('id')
  const id = parseInt(idStr)
  if (!Number.isInteger(id) || id < 0) {
    c.status(400)
    return c.json({ error: 'Invalid id' })
  }


  const applications = await searchApplicationBySchoolId(id)

  return c.json(applications)
})

const port = 3000
console.log(`Server is running on port ${port}`)

serve({
  fetch: app.fetch,
  port
})
