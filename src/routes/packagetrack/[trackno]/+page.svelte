<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import ActionBar from '$components/ActionBar.svelte';
    import { storePost } from '$lib/storeFetch';

    import type { PageData } from './$types';
    export let data: PageData;

    async function forceRefresh() {
        data = await storePost({ fetch }, ['package_tracking', data.track_no], {});
    }
</script>

<svelte:head>
    <title>Package: {data.track_no} ({data.carrier})</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/packagetrack" />
    Package:
    {#if data.notes}
        {data.notes}
    {/if}{#if !data.notes}
        <code>{data.track_no}</code> ({data.carrier})
    {/if}
</h1>

<ActionBar>
    <li><a href="/packagetrack/{data.track_no}/edit">Edit</a></li>
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
            {data.marked}
        </li>
    {/if}

    <li>
        <strong>Tracking number:</strong>
        <code>{data.track_no}</code>
    </li>

    <li>
        <strong>Carrier:</strong>
        <code>{data.carrier}</code>
    </li>

    <li>
        <strong>Last fetched:</strong>
        {data.updated}
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
                    ({obj.updated})
                </li>
            {/each}
        </ul>
    </li>
</ul>
