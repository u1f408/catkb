export const API_BASE: string | null = null;
export const apiBase = (): string => API_BASE !== null ? API_BASE : window.location.origin;

// this is really just to get the typescript warnings to shut up lmaooooo
type StoreParams = { fetch: (url: string, params?: any) => Promise<Response>, } & Record<string, any>;

export async function storeFetch({ fetch }: StoreParams, path: string[], params = {}) {
    var apiUrl = new URL(`${apiBase()}/v1/${path.join('/')}`);
    Object.entries(params).forEach(([k, v]) => apiUrl.searchParams.set(k as string, v as any));
    let req = await fetch(apiUrl.toString());
    return await req.json();
}

export async function storePost({ fetch }: StoreParams, path: string[], body: Record<string, any>, params = {}) {
    var apiUrl = new URL(`${apiBase()}/v1/${path.join('/')}`);
    Object.entries(params).forEach(([k, v]) => apiUrl.searchParams.set(k as string, v as any));
    let req = await fetch(apiUrl.toString(), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
    });
    return await req.json();
}

export async function storePatch({ fetch }: StoreParams, path: string[], body: Record<string, any>, params = {}) {
    var apiUrl = new URL(`${apiBase()}/v1/${path.join('/')}`);
    Object.entries(params).forEach(([k, v]) => apiUrl.searchParams.set(k as string, v as any));
    let req = await fetch(apiUrl.toString(), {
        method: 'PATCH',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
    });
    return await req.json();
}
