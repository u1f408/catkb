<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>Search{data.query ? ": " + data.query : ''}</title>
</svelte:head>

<h1>
    {#if data.query}
        <HeaderParentLink href="/search?" />
    {/if}

    Search{data.query ? ": " + data.query : ''}
</h1>

{#if !data.query}
    <form class="bigform" method="GET">
        <label for="query">Search query:</label>
        <input type="text" id="query" name="q">

        <button type="submit">Search</button>
    </form>
{/if}

{#if data.query}
    <strong>{data.results.length} results{data.results.length > 0 ? ':' : '.'}</strong>
    <ul class="attrlist">
        {#each data.results as entry}
            <li>
                <a href="/{entry._type}/{entry.id}">
                    <strong>{entry.title}</strong>
                    ({entry._type})
                </a>
            </li>
        {/each}
    </ul>
{/if}
