<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import { storeFetch, storePost } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submit(input: string) {
        error = null;
        var barcode = null;
        try {
            barcode = await storeFetch({ fetch }, ['barcode'], { id: input });
            error = "Barcode is already assigned!";
            return;
        } catch {}

        try {
            await storePost({ fetch }, ['barcode'], {
                id: input,
                ptr_type: 'container',
                ptr_id: data.id,
            });
        } catch (nex: any) {
            error = `??? ${nex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/container/${data.id}`);
    }
</script>

<svelte:head>
    <title>{data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/container/{data.id}" />
    Assign barcode: {data.title}
</h1>

{#if data.barcodes.length}
<div class="message warning">
    One or more barcodes are already assigned!
</div>
{/if}

<BarcodeInput onscan={submit} />
{#if error}<div class="message error">{error}</div>{/if}
