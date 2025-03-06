<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import { storePost } from '$lib/storeFetch';
    import { goto, invalidate, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submit(e: SubmitEvent) {
        e.preventDefault();

        var upd = null;
        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            upd = await storePost({ fetch }, ['project', data.id, 'update'], fr);
        } catch (ex: any) {
            error = `Failed to create project update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/project/${data.id}/update/${upd.id}`);
    }
</script>

<svelte:head>
    <title>Add update: {data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/project/{data.id}" />
    Add update: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="description">Description:</label>
    <textarea name="description" id="description"></textarea>

    <button type="submit">Update</button>
</form>
