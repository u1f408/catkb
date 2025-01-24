import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import * as child_process from 'node:child_process';
import * as crypto from 'node:crypto';

const getVersion = () => {
    let rev = child_process.execSync('git describe --always --abbrev=0 --dirty').toString().trim();
    if (rev.indexOf('-dirty') != -1) {
        let data = child_process.execSync('git status --porcelain=2').toString().trim();
        rev += '+' + crypto.createHash('sha1').update(data).digest('hex');
    }

    return rev;
};

/** @type {import('@sveltejs/kit').Config} */
const config = {
    preprocess: vitePreprocess(),

    kit: {
        adapter: adapter({
            fallback: 'index.html',
        }),

        alias: {
            '$components': "src/components",
        },

        version: {
            name: getVersion(),
        },
    },
};

export default config;
