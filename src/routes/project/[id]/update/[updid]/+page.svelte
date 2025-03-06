<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';
    import HeaderParentLink from '$components/HeaderParentLink.svelte';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>{data.project.title} - update {data.update.created}</title>
</svelte:head>

<h1>
    <HeaderParentLink href="/project/{data.project.id}" />
    {data.project.title} - update {data.update.created}
</h1>

<ActionBar>
    <li><a href="/project/{data.project.id}/update/{data.update.id}/edit">Edit</a></li>
</ActionBar>

{#if data.update.description_html}
    <div class="notebody">{@html data.update.description_html}</div>
{/if}

<div id="updImages" class="attrimage-container">
    {#each data.update.images as img}
        <a class="attrimage" href={img.image_url} target="_blank">
            <img src={img.thumb_url} alt={img.id} title={img.id}>
        </a>
    {/each}
</div>
