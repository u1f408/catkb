<script lang="ts">
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import { goto } from '$app/navigation';
    import { storeFetch } from '$lib/storeFetch';

    async function scanRedirect(input: string) {
        var data = null;
        try {
            data = await storeFetch({ fetch }, ['barcode'], { id: input });
        } catch (ex) {
            console.error(ex);
            return;
        }

        if (data) {
            return await goto(`/${data.ptr_type}/${data.ptr_id}`);
        }
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

    header > a {
        color: #000;
        text-decoration: none;
        font-weight: bold;
    }

    header > a:visited {
        color: inherit;
    }
</style>

<header class="main-nav">
    <a href="/">CatKB</a>
    <BarcodeInput onscan={scanRedirect} />
</header>

<main>
    <slot></slot>
</main>
