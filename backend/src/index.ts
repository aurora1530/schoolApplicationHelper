import { serve } from '@hono/node-server'
import { Hono } from 'hono'
import { searchSchoolsByName } from './lib/prisma/search'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono!')
})

app.get('/search', async (c) => {
  const query = c.req.query('q') ?? ''
  if (!query) {
    c.status(400)
    return c.json({  error: 'Query is required' })
  }

  const schools = await searchSchoolsByName(query)

  return c.json(schools)
})

const port = 3000
console.log(`Server is running on port ${port}`)

serve({
  fetch: app.fetch,
  port
})
