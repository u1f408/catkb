<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import { storePatch } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let body: string = data.body || '';
    let error: string | null = null;

    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            await storePatch({ fetch }, ['note', data.id], fr);
        } catch (ex: any) {
            error = `Failed to update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/note/${data.id}`);
    }
</script>

<svelte:head>
    <title>Edit: {data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/note/{data.id}" />
    Edit: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title" value={data.title}>

    <label for="body">Body:</label>
    <textarea id="body" name="body">{data.body}</textarea>

    <button type="submit">Update</button>
</form>
