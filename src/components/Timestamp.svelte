<script lang="ts">
    import RelativeTime from 'svelte-relative-time';
    let { date } = $props();
</script>

<span>
    <RelativeTime {date} />
    <span>({date.toLocaleString("en-GB")})</span>
</span>
