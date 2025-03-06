<script lang="ts">
    import ActionBar from '$components/ActionBar.svelte';
</script>

<svelte:head>
    <title>CatKB home</title>
</svelte:head>

<h1>Home</h1>

<ActionBar title="Create new">
    <li><a href="/note/create">Note</a></li>
    <li><a href="/part/create">Part</a></li>
    <li><a href="/project/create">Project</a></li>
    <li><a href="/container/create">Container</a></li>
</ActionBar>

<ActionBar title="Tools">
    <li><a href="/sn">SN lookups</a></li>
    <li><a href="/packagetrack">Package tracking</a></li>
</ActionBar>
