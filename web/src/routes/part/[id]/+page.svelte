<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';
    import Modal from '$components/Modal.svelte';

    import type { PageData } from './$types';
    export let data: PageData;

    let imageToggles = Object.fromEntries(Array.from(data.images).map((i) => [i.id, false]));
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
    <li><a href="/part/{data.id}/barcode">Barcode</a></li>
    <li><a href="/part/{data.id}/contain">Contain</a></li>
    <li><a href="/part/{data.id}/images">Images</a></li>
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
                <a href="/container/{ctr.id}">{ctr.id}</a>
            {/each}
        </li>
    {/if}
</ul>

{#if data.description_html}
    <div class="notebody">{@html data.description_html}</div>
{/if}

{#if data.images.length}
    <div class="attrimage-container">
        {#each data.images as image}
            <a href="?" class="attrimage" onclick={() => imageToggles[image.id] = !imageToggles[image.id]}>
                <img src={image.thumb_url} alt={image.id} title={image.id}>
            </a>

            <Modal bind:show={imageToggles[image.id]}>
                <div style="text-align:center">
                    <div style="margin-bottom:1rem">
                        <a href={image.image_url} target="_blank">
                            <code>{image.id}</code>
                        </a>
                    </div>

                    <img src={image.image_url} style="height:auto;width:100%;" alt={image.id} title={image.id}>
                </div>
            </Modal>
        {/each}
    </div>
{/if}
