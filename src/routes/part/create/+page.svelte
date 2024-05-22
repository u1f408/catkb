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
            created = await storePost({ fetch }, ['part'], data);
        } catch (ex: any) {
            error = `Failed to create: ${ex.toString()}`;
            return;
        }

        return await goto(`/part/${created.id}`);
    }
</script>

<svelte:head>
    <title>Create part</title>
</svelte:head>

<h1>Create part</h1>
{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title">

    <label for="count_onhand">On hand:</label>
    <input type="number" id="count_onhand" name="count_onhand" min="0" step="1">

    <input type="hidden" name="description" value={description} />
    <Editor id="description" label="Description:" bind:value={description} />

    <button type="submit">Create</button>
</form>
