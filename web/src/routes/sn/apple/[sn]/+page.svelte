<script lang="ts">
    import HeaderParentLink from '$components/HeaderParentLink.svelte';
    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>Apple serial: {data.sn}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/sn/apple" />
    Apple serial: <code>{data.sn}</code>
</h1>

<ul class="attrlist">
    {#if data.marketing_name}
        <li>
            <strong>Marketing name:</strong>
            {data.marketing_name}
        </li>
    {/if}
    {#if data.model_identifier}
        <li>
            <strong>Model identifier:</strong>
            <code>{data.model_identifier}</code>
        </li>
    {/if}
    {#if data.model_family}
        <li>
            <strong>Model family:</strong>
            <code>{data.model_family}</code>
        </li>
    {/if}
</ul>
