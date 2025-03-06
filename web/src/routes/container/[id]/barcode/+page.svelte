<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import BarcodeInput from '$components/BarcodeInput.svelte';

    import { storeFetch, storePost, storeDelete } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submitAssign(input: string) {
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

    function submitRemove(input: string) {
        return async function submitRemoveInner() {
            error = null;
            try {
                await storeDelete({ fetch }, ['barcode'], { id: input });
            } catch (nex: any) {
                error = `??? ${nex.toString()}`;
                return;
            }

            await invalidateAll();
        }
    }
</script>

<svelte:head>
    <title>{data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/container/{data.id}" />
    Barcode: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<section style="margin-bottom:1rem">
    <BarcodeInput placeholder="Scan or enter a barcode to assign it" onscan={submitAssign} />
</section>

{#if data.barcodes.length}
    <strong>Assigned barcodes:</strong>

    <ul>
    {#each data.barcodes as bc}
        <li>
            <code>{bc}</code>

            <br>
            <button onclick={submitRemove(bc)}>Remove</button>
        </li>
    {/each}
    </ul>
{/if}
