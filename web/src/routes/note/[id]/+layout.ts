import type { LayoutLoad } from './$types';
import { storeFetch } from '$lib/storeFetch';

export const load: LayoutLoad = async ({ fetch, params }) =>
    await storeFetch({ fetch }, ['note', params.id]);
