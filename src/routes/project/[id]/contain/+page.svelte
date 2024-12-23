<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import { storeFetch, storePost, storeDelete } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submit(input: string) {
        error = null;
        var ctr = null;
        try {
            let data = await storeFetch({ fetch }, ['barcode'], { id: input });
            if (data.ptr_type !== "container") throw "not a container";
            ctr = await storeFetch({ fetch }, ['container', data.ptr_id]);
        } catch (ex: any) {
            error = `No container found with that barcode! ${ex.toString()}`;
            return;
        }

        try {
            await storePost({ fetch }, ['container', ctr.id, 'children'], {
                ptr_type: 'project',
                ptr_id: data.id,
            });
        } catch (nex: any) {
            error = `??? ${nex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/project/${data.id}`);
    }

    function submitRemove(ctrid: string, childid: string) {
        return async function submitRemoveInner() {
            error = null;
            try {
                await storeDelete({ fetch }, ['container', ctrid, 'children', childid]);
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
    <HeaderParentLink href="/project/{data.id}" />
    Contain: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}
<BarcodeInput onscan={submit} />

{#if data.within.length}
    <strong>Contained within:</strong>

    <ul>
    {#each data.within as ctr}
        <li>
            <code>{ctr.id}</code>

            <br>
            <button onclick={submitRemove(ctr.id, ctr.child)}>Remove</button>
        </li>
    {/each}
    </ul>
{/if}
