# CatKB web

## Development

```bash
npm install && npm run dev
```

By default, this app expects the Ruby API and itself to be on the same
"virtual host" - that is, with a real web server reverse proxying `/v1/*`
to the Ruby app, with everything else falling back to the SvelteKit app.
To run the Ruby app on a different host/port, set the `API_BASE` variable
in `src/lib/storeFetch.ts`.
