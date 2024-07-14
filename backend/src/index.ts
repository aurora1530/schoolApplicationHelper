import { serve } from '@hono/node-server';
import { Hono } from 'hono';
import { searchSchoolsByName } from './lib/prisma/searchHighSchool';
import { searchApplicationBySchoolId } from './lib/prisma/searchApplication';

const app = new Hono();

app.get('/', (c) => {
  return c.text('Hello Hono!');
});

app.get('/search/highSchools', async (c) => {
  const query = c.req.query('q') ?? '';
  const page = parseInt(c.req.query('page') ?? '1');
  const prefectures = c.req.query('prefectures')?.split(',') ?? [];
  console.log(
    `path: ${c.req.path}, query: ${query}, page: ${page}, prefectures: ${prefectures}`
  );

  const { schools, count, pageCount } = await searchSchoolsByName(
    query,
    page,
    prefectures
  );

  return c.json({ schools, count, pageCount });
});

app.get('/search/highSchools/:id', async (c) => {
  const idStr = c.req.param('id');
  console.log(`path: ${c.req.path}, id: ${idStr}`);
  const id = parseInt(idStr);
  if (!Number.isInteger(id) || id < 0) {
    c.status(400);
    return c.json({ error: 'Invalid id' });
  }

  const applications = await searchApplicationBySchoolId(id);
  return c.json({ applications });
});

const port = 3000;
console.log(`Server is running on port ${port}`);

serve({
  fetch: app.fetch,
  port,
});
