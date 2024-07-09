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
    Package: <code>{data.track_no}</code> (<code>{data.carrier}</code>)
</h1>

<ActionBar>
    <li><a href="/packagetrack/{data.track_no}/edit">Edit</a></li>
</ActionBar>

<ul class="attrlist">
    <li>
        <strong>Last fetched:</strong>
        {data.updated}
    </li>

    {#if data.notes}
        <li>
            <strong>Notes:</strong>
            {data.notes}
        </li>
    {/if}

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
