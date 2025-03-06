<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import ActionBar from '$components/ActionBar.svelte';
    import Modal from '$components/Modal.svelte';
    import Timestamp from '$components/Timestamp.svelte';
    import { storePost } from '$lib/storeFetch';

    import type { PageData } from './$types';
    export let data: PageData;

    let barcodeModalShow = false;

    async function forceRefresh() {
        data = await storePost({ fetch }, ['package_tracking', data.track_no], {});
    }
</script>

<svelte:head>
    <title>Package: {data.track_no} ({data.carrier_friendly})</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/packagetrack" />
    Package:
    {#if data.notes}
        {data.notes}
    {:else}
        <code>{data.track_no}</code> ({data.carrier_friendly})
    {/if}
</h1>

<ActionBar>
    <li><a href="/packagetrack/{data.track_no}/edit">Edit</a></li>
    <li><a href="?" onclick={() => barcodeModalShow = true}>Show barcode</a></li>
    <li><a href="?" onclick={forceRefresh}>Force refresh</a></li>
</ActionBar>

<ul class="attrlist">
    {#if data.notes}
        <li>
            <strong>Notes:</strong>
            {data.notes}
        </li>
    {/if}

    {#if data.marked}
        <li>
            <strong>Marked:</strong>
            <Timestamp date={data.marked} />
        </li>
    {/if}

    <li>
        <strong>Tracking number:</strong>

        {#if data.canonical_url}
            <a href={data.canonical_url} target="_blank">
                <code>{data.track_no}</code>
            </a>
        {:else}
            <code>{data.track_no}</code>
        {/if}
    </li>

    <li>
        <strong>Carrier:</strong>
        <span>{data.carrier_friendly}</span>
        (<code>{data.carrier}</code>)
    </li>

    <li>
        <strong>Last fetched:</strong>
        <Timestamp date={data.updated} />
    </li>

    <li>
        <strong>Tracking updates:</strong>
        <ul>
            {#if data.updates.length == 0}
                <li>No updates yet!</li>
            {/if}
            {#each data.updates as obj (obj.updated)}
                <li>
                    <strong>{obj.status}</strong>:
                    <span>{obj.description}</span>
                    &mdash;
                    <Timestamp date={obj.updated} />
                </li>
            {/each}
        </ul>
    </li>
</ul>

<Modal bind:show={barcodeModalShow}>
    <div style="text-align:center">
        <strong>{data.carrier_friendly}</strong>
        <aside class="barcodeDisplayFull" style="margin-top:1rem">
            {@html data.barcode_svg}
        </aside>
        <code>{data.track_no}</code>
    </div>
</Modal>
