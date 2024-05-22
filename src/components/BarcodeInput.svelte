<script lang="ts">
    type ScanHandler = (input: string) => void;
    interface BarcodeInputProps {
        placeholder?: string;
        onscan: ScanHandler;
    }

    let { placeholder, onscan }: BarcodeInputProps = $props();
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
    <input name="scanInput" type="text" placeholder={placeholder}>
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
