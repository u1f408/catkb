<script lang="ts">
    import Editor from '$components/Editor.svelte';
    import { storePost } from '$lib/storeFetch';
    import { goto } from '$app/navigation';

    let description: string = "";
    let error: string | null = null;
    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        var created = null;
        let data = Object.fromEntries((new FormData(e.target as HTMLFormElement)).entries());
        console.log(data);

        try {
            created = await storePost({ fetch }, ['project'], data);
        } catch (ex: any) {
            error = `Failed to create: ${ex.toString()}`;
            return;
        }

        return await goto(`/project/${created.id}`);
    }
</script>

<svelte:head>
    <title>Create project</title>
</svelte:head>

<h1>Create project</h1>
{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title">

    <input type="hidden" name="description" value={description} />
    <Editor id="description" label="Description:" bind:value={description} />

    <button type="submit">Create</button>
</form>
