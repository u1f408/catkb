<script lang="ts">
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import ActionBar from '$components/ActionBar.svelte';
    import { goto } from '$app/navigation';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>Package tracking</title>
</svelte:head>

<h1>
    Package tracking
</h1>

<ActionBar>
    <li><a href="/packagetrack/create">New query</a></li>
    <li><a href="/packagetrack/mark">Bulk mark</a></li>
</ActionBar>

<section style="margin-bottom:1rem">
    <BarcodeInput placeholder="Scan or enter a known package tracking number..." onscan={async (input: string) => await goto(`/packagetrack/${input}`)} />
</section>

{#if data.undelivered.length > 0}
    <section>
        <strong>Undelivered packages:</strong>
        <ul>
            {#each data.undelivered as obj (obj.track_no)}
                <li>
                    <a href="/packagetrack/{obj.track_no}">
                        {#if obj.notes}
                            {obj.notes}
                        {/if}{#if !obj.notes}
                            <code>{obj.track_no}</code> ({obj.carrier})
                        {/if}
                    </a> -
                    {obj.latest_update.description}
                    ({obj.latest_update.updated})
                </li>
            {/each}
        </ul>
    </section>
{/if}

{#if data.unmarked.length > 0}
    <section>
        <strong>Delivered but unmarked packages:</strong>
        <ul>
            {#each data.unmarked as obj (obj.track_no)}
                <li>
                    <a href="/packagetrack/{obj.track_no}">
                        {#if obj.notes}
                            {obj.notes}
                        {/if}{#if !obj.notes}
                            <code>{obj.track_no}</code> ({obj.carrier})
                        {/if}
                    </a> -
                    {obj.latest_update.description}
                    ({obj.latest_update.updated})
                </li>
            {/each}
        </ul>
    </section>
{/if}
