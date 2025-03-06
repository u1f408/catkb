import type { LayoutLoad } from './$types';
import { storeFetch, storeFetchPlain } from '$lib/storeFetch';

export const load: LayoutLoad = async ({ fetch, params }) => {
    let resp = await storeFetch({ fetch }, ['project', params.id]);
    resp.updates = await storeFetch({ fetch }, ['project', params.id, '+updates']);
    resp.barcode_svgs = await Promise.all(resp.barcodes.map((bar: string) =>
        storeFetchPlain({ fetch }, ['barcode.svg'], { id: bar }).then((req) => req.text())));

    return resp;
};
