<script lang="ts">
    import RelativeTime from 'svelte-relative-time';

    let { date } = $props();
    if (!(date instanceof Date)) {
        let dateStr = date.toString()
            .replace(/^(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})/, '$1T$2')
            .replace(/ \+0000$/, 'Z')
            .replace(/ ([\+\-])(\d{2})(\d{2})$/, '$1$2:$3');

        date = new Date(dateStr);
    }
</script>

<span>
    <RelativeTime {date} />
    <span>({date.toLocaleString("en-GB")})</span>
</span>
