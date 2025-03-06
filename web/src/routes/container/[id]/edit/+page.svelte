<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import { storePatch, storeDelete } from '$lib/storeFetch';
    import { goto, invalidateAll } from '$app/navigation';
    import type { PageData } from './$types';

    export let data: PageData;
    let error: string | null = null;

    async function submit(e: SubmitEvent) {
        e.preventDefault();

        error = null;
        try {
            let fr = Object.fromEntries((new FormData(e.target! as HTMLFormElement)).entries());
            await storePatch({ fetch }, ['container', data.id], fr);
        } catch (ex: any) {
            error = `Failed to update: ${ex.toString()}`;
            return;
        }

        await invalidateAll();
        return await goto(`/container/${data.id}`);
    }

    function submitChildRemove(child_id: string) {
        return async function submitChildRemoveInner() {
            error = null;
            try {
                await storeDelete({ fetch }, ['container', data.id, 'children', child_id], {});
            } catch (ex: any) {
                error = `Failed to remove child: ${ex.toString()}`;
                return;
            }

            await invalidateAll();
        }
    }
</script>

<svelte:head>
    <title>Edit: {data.title}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/container/{data.id}" />
    Edit: {data.title}
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form onsubmit={submit} class="bigform">
    <label for="title">Title:</label>
    <input type="text" id="title" name="title" placeholder="Title" value={data.title}>

    <label for="location">Location:</label>
    <input type="text" id="location" name="location" placeholder="Location" value={data.location}>

    <button type="submit">Update</button>
</form>

<section>
    <strong>Container contents:</strong>

    <ul class="attrlist">
    {#each Object.keys<string>(data.children) as child_id}
        <li>
            {data.children[child_id]._type}
            <code>{data.children[child_id].id}</code>:
            <strong>{data.children[child_id].title}</strong>
            (child <code>{child_id}</code>)

            <br>
            <button onclick={submitChildRemove(child_id)}>Remove</button>
        </li>
    {:else}
        <li>
            Empty :(
        </li>
    {/each}
    </ul>
</section>
