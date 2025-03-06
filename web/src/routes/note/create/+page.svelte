<script lang="ts">
    import { storePost } from '$lib/storeFetch';
    import { goto } from '$app/navigation';

    let body: string = "";
    let error: string | null = null;
    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        var created = null;
        let data = Object.fromEntries((new FormData(e.target as HTMLFormElement)).entries());
        console.log(data);

        try {
            created = await storePost({ fetch }, ['note'], data);
        } catch (ex: any) {
            error = `Failed to create: ${ex.toString()}`;
            return;
        }

        return await goto(`/note/${created.id}`);
    }
</script>

<svelte:head>
    <title>Create note</title>
</svelte:head>

<h1>Create note</h1>
{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title">

    <label for="body">Body:</label>
    <textarea id="body" name="body"></textarea>

    <button type="submit">Create</button>
</form>
