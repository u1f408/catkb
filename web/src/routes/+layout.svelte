<script lang="ts">
    import { goto } from '$app/navigation';
    import BarcodeInput from '$components/BarcodeInput.svelte';
    import Modal from '$components/Modal.svelte';

    import { Icon } from 'svelte-icons-pack'
    import { AiOutlineSearch } from 'svelte-icons-pack/ai';

    let showSearch = false;
    async function searchRedirect(e: SubmitEvent) {
        e.preventDefault();
        showSearch = false;

        let data = Object.fromEntries((new FormData(e.target as HTMLFormElement)).entries());
        return await goto(`/search?q=${encodeURIComponent(data.q)}`);
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
        display: flex;
        flex-flow: row nowrap;
    }

    header .main-nav-btn {
        display: block;
        padding: 0 0.25rem;
    }
</style>

<Modal bind:show={showSearch}>
    <form onsubmit={searchRedirect} class="bigform">
        <!-- svelte-ignore a11y_autofocus -->
        <input type="text" name="q" placeholder="Search..." autofocus>
        <button type="submit">Search!</button>
    </form>
</Modal>

<header class="main-nav">
    <a href="/">CatKB</a>
    <div class="main-nav-right">
        <a href="?" onclick={() => showSearch = true} class="main-nav-btn">
            <Icon src={AiOutlineSearch} />
        </a>
    </div>
</header>

<main>
    <slot></slot>
</main>
