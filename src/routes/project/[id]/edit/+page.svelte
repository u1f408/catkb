<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import Editor from '$components/Editor.svelte';

    import { storePatch } from '$lib/storeFetch';
    import { goto, invalidate, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let description: string = data.description || '';
    let error: string | null = null;

    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            await storePatch({ fetch }, ['project', data.id], fr);
        } catch (ex: any) {
            error = `Failed to update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/project/${data.id}`);
    }
</script>

<svelte:head>
    <title>Edit: {data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/project/{data.id}" />
    Edit: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title" value={data.title}>

    <input type="hidden" name="description" value={description} />
    <Editor id="description" label="Description:" bind:value={description} />

    <button type="submit">Update</button>
</form>
