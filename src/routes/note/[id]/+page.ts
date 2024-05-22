import type { PageLoad } from './$types';
import { storeFetch } from '$lib/storeFetch';

export const load: PageLoad = async ({ fetch, params }) =>
    await storeFetch({ fetch }, ['note', params.id]);
