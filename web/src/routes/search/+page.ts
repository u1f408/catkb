import type { PageLoad } from './$types';
import { storeFetch } from '$lib/storeFetch';
import { goto } from '$app/navigation';

export const load: PageLoad = async ({ fetch, url }) => {
    let query = url.searchParams.get('q');
    if (!query) return null;

    let res = await storeFetch({ fetch }, ['search'], { q: query });
    if (res.results.length == 1) {
        return await goto(`/${res.results[0]._type}/${res.results[0].id}`);
    }

    return res;
}
