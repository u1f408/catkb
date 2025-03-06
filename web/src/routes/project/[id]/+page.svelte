<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';
    import Modal from '$components/Modal.svelte';

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
    <li><a href="/project/{data.id}/edit">Edit</a></li>
    <li><a href="/project/{data.id}/barcode">Barcode</a></li>
    <li><a href="/project/{data.id}/contain">Contain</a></li>
    <li><a href="/project/{data.id}/update">Add update</a></li>
    <li>
        <a href="/project/{data.id}/images">
            Images
            {#if data.images.length}({data.images.length}){/if}
        </a>
    </li>
</ActionBar>

<ul class="attrlist">
    {#if data.within.length}
        <li>
            <strong>Found in:</strong>
            {#each data.within as ctr}
                <a href="/container/{ctr.id}">{ctr.id}</a>
            {/each}
        </li>
    {/if}
</ul>

{#if data.description_html}
    <div class="notebody">{@html data.description_html}</div>
{/if}

{#if data.updates.length}
    <div class="projectUpdates">
        {#each data.updates as upd (upd.id)}
            <div class="projectUpdate" data-id={upd.id}>
                <h3><a href="/project/{data.id}/update/{upd.id}">{upd.created}</a></h3>
                <div class="projectUpdate-body notebody">
                    {@html upd.description_html}
                    {#if upd.images.length}
                        <p>
                            <a href="/project/{data.id}/update/{upd.id}#updImages">({upd.images.length} images)</a>
                        </p>
                    {/if}
                </div>
            </div>
        {/each}
    </div>
{/if}
