import type { PageLoad } from './$types';
import { storeFetch } from '$lib/storeFetch';

export const load: PageLoad = async ({ fetch, url }) => {
    let query = url.searchParams.get('q');
    if (query) {
        return await storeFetch({ fetch }, ['search'], { q: query });
    }

    return null;
}
