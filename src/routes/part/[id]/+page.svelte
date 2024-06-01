<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>{data.title}</title>
</svelte:head>

{#if data.barcode_svgs.length}
    <aside class="barcodeDisplay">
        {@html data.barcode_svgs[0]}
    </aside>
{/if}

<h1>{data.title}</h1>
<ActionBar>
    <li><a href="/part/{data.id}/edit">Edit</a></li>
    <li><a href="/part/{data.id}/barcode">Assign barcode</a></li>
    <li><a href="/part/{data.id}/contain">Contain</a></li>
</ActionBar>

<ul class="attrlist">
    <li>
        <strong>On hand:</strong>
        {data.count_onhand}
    </li>

    {#if data.within.length}
        <li>
            <strong>Found in:</strong>
            {#each data.within as ctr}
                <a href="/container/{ctr}">{ctr}</a>
            {/each}
        </li>
    {/if}
</ul>

{#if data.description}
    <div class="notebody">{@html data.description}</div>
{/if}
