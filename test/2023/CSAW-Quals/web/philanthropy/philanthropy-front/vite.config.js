import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import obfuscatorPlugin from "vite-plugin-javascript-obfuscator";


// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    react(),
    obfuscatorPlugin({
      options: {
        sourceMap: false,
        sourceMapBaseUrl: '',
        sourceMapFileName: '',
      },
    })
  ],
  build: {
    sourcemap: false,
    sourcemapExcludeSources: true,
    rollupOptions: {
      // Omit the sourcemap option to disable sourceMappingURL comments
      output: {
        sourcemap: false
      }
    }
  },
});
