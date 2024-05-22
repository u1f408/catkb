<script lang="ts">
    export let id: string;
    export let label: string | null = null;
    export var value: string = "";
    let initialValue = "" + value;

    function handleInput(ev: Event) {
        value = (ev.target as HTMLElement).innerHTML;
        return false;
    }
</script>

{#if label}
    <label for={id}>{@html label}</label>
{/if}

<div id={id} class="editor" contenteditable="true" on:input={handleInput}>
    {@html initialValue}
</div>

<style>
    div.editor {
        flex: 1;
        display: block;
        padding: 0.5rem;
        border: 1px solid #000;
        border-radius: 3px;
    }
</style>
