<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import ImageUpload from '$components/ImageUpload.svelte';
    import { storePatch, storeDelete } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submitEdit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            await storePatch({ fetch }, ['project', data.project.id, 'update', data.update.id], fr);
        } catch (ex: any) {
            error = `Failed to update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/project/${data.project.id}/update/${data.update.id}`);
    }

    async function submitDelete(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            await storeDelete({ fetch }, ['project', data.project.id, 'update', data.update.id]);
        } catch (ex: any) {
            error = `??? ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/project/${data.project.id}`);
    }

    function imgRemove(imgid: string, childid: string) {
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
    <title>{data.project.title} - update {data.update.created}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/project/{data.project.id}/update/{data.update.id}" />
    {data.project.title} - edit update {data.update.created}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submitEdit(e)} class="bigform">
    <label for="description">Description:</label>
    <textarea name="description" id="description">{data.update.description}</textarea>

    <button type="submit">Update</button>
</form>

<div id="updImages">
    <strong>Images:</strong>
    <ImageUpload linkType="project_update" linkId="{data.update.id}" />

    <ul>
        {#each data.update.images as img}
            <li>
                <a href={img.image_url} target="_blank">
                    <code>{img.id}</code>
                </a>
                <br>
                <button on:click={imgRemove(img.id, img.child)}>Remove</button>
            </li>
        {/each}
    </ul>
</div>

<form id="updYeet" on:submit={(e) => submitDelete(e)} class="bigform">
    <strong>Delete update</strong>
    <label for="yeetConfirm">
        <input type="checkbox" id="yeetConfirm" name="yeetConfirm" required>
        Sure about this?
    </label>
    <button type="submit">YEET</button>
</form>
