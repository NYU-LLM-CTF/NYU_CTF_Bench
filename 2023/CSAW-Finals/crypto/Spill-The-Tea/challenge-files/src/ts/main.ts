import {
    Renderer,
    Camera,
    Transform,
    Program,
    Mesh,
    RenderTarget,
    Triangle,
    Vec3,
} from "ogl";
import { autoResize } from "./canvas";

import render_frag from "../shaders/rendertexture.frag";
import rect_vert from "../shaders/rect.vert";
import { Logo, initLogo } from "./logo-entity";
import { Cubes, initCubes } from "./cubes-entity";
import { MouseTracker } from "./mouse";

const renderer = new Renderer({
    antialias: false,
    alpha: true,
    dpr: window.devicePixelRatio,
    autoClear: true,
});

const gl = renderer.gl;
const element = document.getElementById("render");

element?.appendChild(gl.canvas);
gl.clearColor(0.0, 0.0, 0.0, 0.0);

const camera = new Camera(gl, { fov: 35 });
camera.position = [0, 0.5, 3];
camera.lookAt([0, 0, 0]);

const pixelWidth = 384;//256;
const scale = 0.3;

const target = new RenderTarget(gl, {
    depthTexture: true,
    width: pixelWidth * 2,
    height: pixelWidth,
    magFilter: gl.NEAREST,
    premultiplyAlpha: true,
    format: gl.RGBA,
    internalFormat: gl.RGBA
});

autoResize(element!, renderer, (width: number, height: number) => {
    const aspect = width / height;
    camera.perspective({ aspect });
    scene.scale = new Vec3(scale * aspect);
    target.setSize(pixelWidth, pixelWidth / aspect);
});

const scene = new Transform();

const renderProgram = new Program(gl, {
    vertex: rect_vert,
    fragment: render_frag,
    uniforms: {
        t_color: { value: target.texture },
        t_depth: { value: target.depthTexture },
        u_resolution: { value: [target.width, target.height] }
    },
    transparent: true,
});

const renderGeometry = new Triangle(gl);

const renderMesh = new Mesh(gl, { geometry: renderGeometry, program: renderProgram });

const tracker = new MouseTracker(gl);

let logo: Logo;
let cubes: Cubes;

initLogo(gl, scene).then(l => {
    logo = l;
    initCubes(gl, scene).then(c => {
        cubes = c;

        const input = document.getElementById("key");
        input?.addEventListener("input", (e) => cubes.keyChange(e.target?.value))

        requestAnimationFrame(update);
    });
});


//TODO: Delta t?
function update(time: number) {
    requestAnimationFrame(update);

    // For some reason this doesn't work when setting the Euler object directly
    const rot = tracker.getRotation();
    logo.transform.rotation.x = rot.x * 0.95;
    logo.transform.rotation.y = rot.y * 0.95;
    cubes.transform.rotation.x = rot.x * 1.05;
    cubes.transform.rotation.y = rot.y * 1.05;

    logo.update(gl, time);

    // Set background for first render to target
    gl.clearColor(0, 0, 0, 0);

    // Add target property to render call
    renderer.render({ scene, camera, target });

    // Change to final background
    gl.clearColor(0, 0, 0, 0);

    renderer.render({ scene: renderMesh });
}
