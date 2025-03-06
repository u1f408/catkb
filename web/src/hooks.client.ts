import type { HandleClientError } from '@sveltejs/kit';

export const handleError: HandleClientError = async ({ error, event, status, message }) => {
    return {
        message: "uh oh besties!!! " + JSON.stringify({ error, event, status }),
    };
};
