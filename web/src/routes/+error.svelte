<script lang="ts">
    import { page } from '$app/state';
</script>

<h1>{page.status}</h1>
<pre><code>{page.error.message}</code></pre>
