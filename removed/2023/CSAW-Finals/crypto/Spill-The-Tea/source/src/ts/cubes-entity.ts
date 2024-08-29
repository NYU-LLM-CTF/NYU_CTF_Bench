import { Box, Mesh, OGLRenderingContext, Program, Texture, Transform, Vec2 } from "ogl";
import { Entity } from "./entity";

import CubeVert from "../shaders/cubes.vert";
import CubeFrag from "../shaders/cubes.frag";

export async function initCubes(gl: OGLRenderingContext, parent: Transform): Promise<Cubes> {

    // https://registry.khronos.org/webgl/specs/latest/2.0/#TEXTURE_TYPES_FORMATS_FROM_DOM_ELEMENTS_TABLE
    const tex = new Texture(gl, {
        target: gl.TEXTURE_2D,
        level: 0,
        internalFormat: gl.RGBA8UI,
        format: gl.RGBA_INTEGER,
        type: gl.UNSIGNED_BYTE,
        minFilter: gl.NEAREST,
        magFilter: gl.NEAREST
    })

    const img = new Image();
    img.src = 'tex.png';
    await img.decode();
    tex.image = img;
    tex.flipY = false;
    console.log(tex);
    return new Cubes(gl, tex, parent);
}

function makeKey(key: string) {
    let out = Array(4).fill(0);

    for (let i = 0; i < Math.min(4, key.length); i++) {
        out[i] = key.charCodeAt(i)
    }

    console.log(out)
    return out;
}

export class Cubes extends Entity<Transform> {

    constructor(gl: OGLRenderingContext, tex: Texture, parent: Transform) {

        const key = makeKey("");

        const numCubes = 2188;
        const texRes = new Vec2(tex.image!.width, tex.image!.height);

        // For some reason it throws an error if I try making this a integer type
        const texCoord = new Float32Array(numCubes * 2);

        for (let i = 0; i < numCubes; i += 2) {
            texCoord[i] = Math.floor(i % texRes.x);
            texCoord[i + 1] = Math.floor(i / texRes.y)
        }

        const geometry = new Box(gl);
        geometry.addAttribute("texCoord", { instanced: 1, size: 2, data: texCoord });

        const program = new Program(gl, {
            vertex: CubeVert,
            fragment: CubeFrag,
            uniforms: {
                t_sampler: { value: tex },
                u_texRes: { value: texRes },
                u_key: { value: key }
            },
            transparent: true,
            cullFace: false,
        });

        const cube = new Mesh(gl, { mode: gl.TRIANGLES, geometry, program });
        super(cube, parent);
    }

    update(gl: OGLRenderingContext, time: number): void {
    }

    keyChange(input: string) {
        const key = makeKey(input);
        this.transform.program.uniforms.u_key = {
            value: key
        };
    }
}
