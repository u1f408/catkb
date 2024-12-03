<script lang="ts">
    import { apiBase } from '$lib/storeFetch';
    import { invalidateAll } from '$app/navigation';

    interface ImageUploadProps {
        linkType: string;
        linkId: string;
    }

    let { linkType, linkId }: ImageUploadProps = $props();

    async function handleSubmit(ev: SubmitEvent) {
        ev.preventDefault();
        let data = new FormData();
        data.append('image', ev.target.querySelector("input[type=file]").files[0])

        let resp = await (await fetch(`${apiBase()}/v1/image`, { method: 'POST', body: data })).json();

        await fetch(`${apiBase()}/v1/image/${resp.id}/links`, {
            method: 'POST',
            body: JSON.stringify({ ptr_type: linkType, ptr_id: linkId }),
            headers: {
                'Content-Type': 'application/json',
            },
        });

        await invalidateAll();
        return false;
    }
</script>

<form onsubmit={handleSubmit}>
    <input type="file" name="image">
    <button type="submit">Upload</button>
</form>

<style>
    form {
        flex: 1;
        display: flex;
        flex-flow: row wrap;
    }
</style>
