<script lang="ts">
    type ScanHandler = (input: string) => void;
    interface BarcodeInputProps {
        placeholder?: string;
        autofocus?: bool;
        onscan: ScanHandler;
    }

    let { placeholder, onscan, autofocus }: BarcodeInputProps = $props();
    placeholder = placeholder || "Scan a barcode...";

    function handleSubmit(ev: SubmitEvent) {
        ev.preventDefault();
        let el = (ev.target as HTMLFormElement).querySelector('input[name=scanInput]')! as HTMLInputElement;
        let val = el.value;
        el.value = '';
        onscan(val);
        return false;
    }
</script>

<form onsubmit={handleSubmit}>
    <!-- svelte-ignore a11y_autofocus -->
    <input name="scanInput" type="text" placeholder={placeholder} autofocus={autofocus ?? false}>
</form>

<style>
    form {
        flex: 1;
        display: flex;
        flex-flow: row nowrap;
    }

    input {
        flex: 1;
        display: block;
        padding: 0.25rem 0.5rem;
        border: 1px solid #000;
        border-radius: 3px;
    }
</style>
