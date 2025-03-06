<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import { storePost } from '$lib/storeFetch';

    let marked: any[] = [];
    let error: string | null = null;

    async function submit(track_no: string) {
        error = null;

        try {
            var obj = await storePost({ fetch }, ['package_tracking', track_no, 'mark'], {});
            marked = [ ...marked, obj ];
        } catch (ex: any) {
            error = `Failed to mark {track_no}: ${ex.toString()}`;
            return;
        }
    }
</script>

<svelte:head>
    <title>Bulk mark packages</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/packagetrack" />
    Bulk mark packages
</h1>

<section style="margin-bottom:1rem">
    <BarcodeInput placeholder="Scan or enter a known package tracking number..." onscan={async (input: string) => await submit(input)} />
</section>

{#if error}<div class="message error">{error}</div>{/if}

<section>
    <ul>
        {#each marked as obj (obj.track_no)}
            <li>
                <a href="/packagetrack/{obj.track_no}">
                    {#if obj.notes}
                        {obj.notes}
                    {/if}{#if !obj.notes}
                        <code>{obj.track_no}</code> ({obj.carrier})
                    {/if}
                </a>
            </li>
        {/each}
    </ul>
</section>
