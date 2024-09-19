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
</script>

<svelte:head>
    <title>{data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/project/{data.id}" />
    Contain: {data.title}
</h1>

{#if data.within.length}
    <div class="message warning">
        Already in one or more containers:
        {#each data.within as ctr}
            <a href="/container/{ctr}">{ctr}</a>
        {/each}
    </div>
{/if}

{#if error}<div class="message error">{error}</div>{/if}
<BarcodeInput onscan={submit} />
