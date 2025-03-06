<script lang="ts">
    export let title: string = "Actions";
</script>

<ul class="actionbar">
    <li data-header><strong>{title}:</strong></li>
    <slot></slot>
</ul>
