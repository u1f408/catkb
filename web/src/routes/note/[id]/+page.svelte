<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';

    import type { PageData } from './$types';
    export let data: PageData;
</script>

<svelte:head>
    <title>{data.title}</title>
</svelte:head>

<h1>{data.title}</h1>
<ActionBar>
    <li><a href="/note/{data.id}/edit">Edit</a></li>
</ActionBar>

<ul class="attrlist">
    <!-- meow -->
</ul>

{#if data.body_html}
    <div class="notebody">{@html data.body_html}</div>
{/if}
