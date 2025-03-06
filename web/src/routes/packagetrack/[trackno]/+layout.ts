import type { LayoutLoad } from './$types';
import { storeFetch, storeFetchPlain } from '$lib/storeFetch';

export const load: LayoutLoad = async ({ fetch, params }) => {
    let data = await storeFetch({ fetch }, ['package_tracking', params.trackno], {});
    data.barcode_svg =
        await (await storeFetchPlain({ fetch }, ['barcode.svg'], { id: data.track_no, fmt: "code128" })).text();

    return data;
}
