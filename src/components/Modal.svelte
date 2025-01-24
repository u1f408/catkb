<script lang="ts">
    import portal from '$lib/portal';
    let { show = $bindable(false), children } = $props();
</script>

{#if show}
    <div use:portal class="modal-container">
        <div class="modal">
            {@render children?.()}

            <div class="modal-close">
                <a href="?" onclick={() => show = false}>Close</a>
            </div>
        </div>
    </div>
{/if}

<style>
    .modal-container {
        position: fixed;
        top: 0;
        left: 0;
        bottom: 0;
        right: 0;

        background: rgba(0, 0, 0, 0.95);
        display: flex;
    }

    .modal-container .modal {
        margin: 1rem auto auto auto;
        padding: 1rem;
        background: white;
        border-radius: 3px;
        width: 100%;
        max-width: calc(100vw - 2rem);
        max-height: calc(100vh - 2rem);
        overflow-x: hidden;
        overflow-y: auto;
    }

    .modal-container .modal .modal-close {
        margin: 1rem 0 0 0;
        text-align: center;
        font-size: 0.8rem;
    }

    .modal-container .modal .modal-close a,
    .modal-container .modal .modal-close a:visited {
        color: hsl(0, 0%, 40%);
    }

    .modal-container .modal .modal-close a {
        text-decoration: none;
    }

    .modal-container .modal .modal-close a:focus,
    .modal-container .modal .modal-close a:hover {
        text-decoration: underline;
    }

</style>
