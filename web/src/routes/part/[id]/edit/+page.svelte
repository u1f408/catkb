<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import { storePatch } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            await storePatch({ fetch }, ['part', data.id], fr);
        } catch (ex: any) {
            error = `Failed to update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/part/${data.id}`);
    }
</script>

<svelte:head>
    <title>Edit: {data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/part/{data.id}" />
    Edit: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title" value={data.title}>

    <label for="count_onhand">On hand:</label>
    <input type="number" id="count_onhand" name="count_onhand" min="0" step="1" value={data.count_onhand}>

    <label for="generic_type">Type (generic):</label>
    <input type="text" id="generic_type" name="generic_type" placeholder="Type (generic)" value={data.generic_type}>

    <label for="form_factor">Form factor:</label>
    <input type="text" id="form_factor" name="form_factor" placeholder="Form factor" value={data.form_factor}>

    <label for="description">Description:</label>
    <textarea name="description" id="description">{data.description}</textarea>

    <button type="submit">Update</button>
</form>
