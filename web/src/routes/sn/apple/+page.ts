import type { PageLoad } from './$types';
import { storeFetch } from '$lib/storeFetch';

export const load: PageLoad = async ({ fetch }) =>
    await storeFetch({ fetch }, ['serial_lookup', 'apple', '+latest'], {});
