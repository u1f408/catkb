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

{#if error}<div class="message error">{error}</div>{/if}
<ImageUpload linkType="project" linkId="{data.id}" />

{#if data.images.length}
    <strong>Existing images:</strong>

    <ul>
    {#each data.images as img}
        <li>
            <div class="attrimage">
                <img src="{img.thumb_url}" alt="{img.id}">
            </div>
            <br>
            <code>{img.id}</code>

            <br>
            <button onclick={submitRemove(img.id, img.child)}>Remove</button>
        </li>
    {/each}
    </ul>
{/if}
