<script lang="ts">
    import { storePost } from '$lib/storeFetch';
    import { goto } from '$app/navigation';

    let error: string | null = null;
    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        var created = null;
        let data = Object.fromEntries((new FormData(e.target as HTMLFormElement)).entries());
        console.log(data);

        try {
            created = await storePost({ fetch }, ['container'], data);
        } catch (ex: any) {
            error = `Failed to create: ${ex.toString()}`;
            return;
        }

        return await goto(`/container/${created.id}`);
    }
</script>

<svelte:head>
    <title>Create container</title>
</svelte:head>

<h1>Create container</h1>
{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title">

    <label for="location">Location:</label>
    <input type="text" id="location" name="location" placeholder="Location">

    <button type="submit">Create</button>
</form>
