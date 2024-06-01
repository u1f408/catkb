import type { PageLoad } from './$types';
import { storeFetch, storeFetchPlain } from '$lib/storeFetch';

export const load: PageLoad = async ({ fetch, params }) => {
    let resp = await storeFetch({ fetch }, ['project', params.id]);
    resp.barcode_svgs = await Promise.all(resp.barcodes.map((bar: string) =>
        storeFetchPlain({ fetch }, ['barcode.svg'], { id: bar }).then((req) => req.text())));

    return resp;
};
