<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import ActionBar from '$components/ActionBar.svelte';

    import type { PageData } from './$types';
    export let data: PageData;
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
