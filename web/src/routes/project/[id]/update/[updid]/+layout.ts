import type { LayoutLoad } from './$types';
import { storeFetch, storeFetchPlain } from '$lib/storeFetch';

export const load: LayoutLoad = async ({ fetch, params }) => {
    console.log(`update params ${params}`);
    return {
        project: await storeFetch({ fetch }, ['project', params.id]),
        update: await storeFetch({ fetch }, ['project', params.id, 'update', params.updid]),
    };
};
