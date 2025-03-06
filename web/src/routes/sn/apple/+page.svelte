<script lang="ts">
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import { goto } from '$app/navigation';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>Apple serial number lookup</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/sn" />
    Apple serial number lookup
</h1>

<section style="margin-bottom:1rem">
    <BarcodeInput placeholder="Scan or enter an Apple serial number..." onscan={async (input: string) => await goto(`/sn/apple/${input}`)} />
</section>

<section>
    <strong>Last fetched:</strong>
    <ul>
        {#each data.latest as obj (obj.sn)}
            <li>
                <a href="/sn/apple/{obj.sn}"><code>{obj.sn}</code></a> -
                {obj.marketing_name || obj.model_identifier || obj.model_family}
                ({obj.updated})
            </li>
        {/each}
    </ul>
</section>
