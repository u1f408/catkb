import type { PageLoad } from './$types';
import { storePost } from '$lib/storeFetch';

export const load: PageLoad = async ({ fetch, params }) =>
    await storePost({ fetch }, ['serial_lookup', 'apple', params.sn], {});
