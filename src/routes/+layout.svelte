<script lang="ts">
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import Modal from '$components/Modal.svelte';
    import { Icon } from 'svelte-icons-pack'
    import { AiOutlineBarcode } from 'svelte-icons-pack/ai';

    import { goto } from '$app/navigation';
    import { storeFetch } from '$lib/storeFetch';

    let showScan = false;
    let scanError: string | null = null;
    async function scanRedirect(input: string) {
        var data = null;
        scanError = null;

        try {
            data = await storeFetch({ fetch }, ['barcode'], { id: input });
            if (!data) throw new Error("no data");
        } catch (ex) {
            console.error(ex);
            scanError = ex.message;
            return;
        }

        return await goto(`/${data.ptr_type}/${data.ptr_id}`);
    }
</script>

<style>
    header {
        flex: 1;
        display: flex;
        flex-flow: row nowrap;
        align-items: center;
        gap: 1rem;
    }

    header a {
        color: #000;
        text-decoration: none;
        font-weight: bold;
    }

    header a:visited {
        color: inherit;
    }

    header .main-nav-right {
        margin: 0 0 0 auto;
    }
</style>

<Modal bind:show={showScan}>
    <BarcodeInput onscan={scanRedirect} autofocus={true} />
    {#if scanError}
        <div class="message error">{scanError}</div>
    {/if}
</Modal>

<header class="main-nav">
    <a href="/">CatKB</a>
    <div class="main-nav-right">
        <a href="?" onclick={() => showScan = true}>
            <Icon src={AiOutlineBarcode} />
        </a>
    </div>
</header>

<main>
    <slot></slot>
</main>
