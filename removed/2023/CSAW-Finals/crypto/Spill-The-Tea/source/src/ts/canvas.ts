import { Renderer } from "ogl";

export function autoResize(element: HTMLElement, renderer: Renderer, callback?: (width: number, height: number) => void) {
    const canvas = renderer.gl.canvas;

    // Setup an observer to fit the canvas to the parent element size
    // From https://webglfundamentals.org/webgl/lessons/webgl-resizing-the-canvas.html
    const resizeObserver = new ResizeObserver((entries) => {
        let width, height;

        for (const entry of entries) {
            // See https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
            if (entry.contentBoxSize) {
                // Firefox implements `contentBoxSize` as a single content rect, rather than an array
                const contentBoxSize = Array.isArray(entry.contentBoxSize)
                    ? entry.contentBoxSize[0]
                    : entry.contentBoxSize;

                width = contentBoxSize.inlineSize;
                height = contentBoxSize.blockSize;
            } else {
                width = entry.contentRect.width
                height = entry.contentRect.height;
            }
        }
        renderer.setSize(width, height);
        if (callback) callback(canvas.width, canvas.height);
    });

    resizeObserver.observe(element, { box: "content-box" });
}
