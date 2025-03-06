<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

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
            created = await storePost({ fetch }, ['package_tracking'], data);
        } catch (ex: any) {
            error = `Failed to create: ${ex.toString()}`;
            return;
        }

        return await goto(`/packagetrack/${created.track_no}`);
    }
</script>

<svelte:head>
    <title>New package query</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/packagetrack" />
    New package query
</h1>

{#if error}<div class="message error">{error}</div>{/if}

<form on:submit={(e) => submit(e)} class="bigform">
    <label for="track_no">Tracking number:</label>
    <input type="text" id="track_no" name="track_no" placeholder="Tracking number">

    <label for="carrier">Carrier:</label>
    <select id="carrier" name="carrier">
        <option value="nzpost">NZ Post (nzpost)</option>
        <option value="aramexnz">Aramex New Zealand (aramexnz)</option>
    </select>

    <label for="direction">Direction:</label>
    <select id="direction" name="direction">
        <option value="incoming">Incoming</option>
        <option value="outgoing">Outgoing</option>
    </select>

    <label for="notes">Notes:</label>
    <input type="text" id="notes" name="notes" placeholder="Notes">

    <button type="submit">Create</button>
</form>
