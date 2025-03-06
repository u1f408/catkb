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
    <li><a href="/container/{data.id}/edit">Edit</a></li>
    <li><a href="/container/{data.id}/barcode">Barcode</a></li>
    <li><a href="/container/{data.id}/contain">Contain</a></li>
</ActionBar>

<ul class="attrlist">
    {#if data.location}
        <li>
            <strong>Location:</strong>
            {data.location}
        </li>
    {/if}

    {#if data.within.length}
        <li>
            <strong>Found in:</strong>
            {#each data.within as ctr}
                <a href="/container/{ctr}">{ctr}</a>
            {/each}
        </li>
    {/if}

    <li>
        <strong>Container contents:</strong>
        <ul class="attrlist">
            {#each Object.values<any>(data.children) as child (child.id)}
                <li><a href="/{child._type}/{child.id}">
                    {#if child._type == "part"}
                        {child.count_onhand}x
                    {/if}
                    <strong>{child.title}</strong>
                    ({child._type})
                </a></li>
            {:else}
                <li>Empty :(</li>
            {/each}
        </ul>
    </li>
</ul>
