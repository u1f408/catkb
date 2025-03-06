<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import ImageUpload from '$components/ImageUpload.svelte';
    import { storeDelete } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    function submitRemove(imgid: string, childid: string) {
        return async function submitRemoveInner() {
            error = null;
            try {
                await storeDelete({ fetch }, ['image', imgid, 'links', childid]);
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
    Images: {data.title}
</h1>

<div>
    <strong>Upload image</strong>
    {#if error}<div class="message error">{error}</div>{/if}
    <ImageUpload linkType="project" linkId={data.id} />
</div>

{#if data.images.length}
    <strong>Existing images</strong>
    <div class="attrimage-container">
        {#each data.images as img}
            <div class="attrimage">
                <div class="attrimage-innertext">
                    <code>{img.id}</code>
                </div>
                <a href={img.image_url} target="_blank">
                    <img src={img.thumb_url} alt={img.id} title={img.id}>
                </a>
                <div class="attrimage-innertext">
                    <button on:click={submitRemove(img.id, img.child)}>Remove</button>
                </div>
            </div>
        {/each}
    </div>
{/if}
