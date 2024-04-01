import { OGLRenderingContext, Transform } from "ogl";

export abstract class Entity<T extends Transform> {
    transform: T;

    constructor(transform: T, parent: Transform) {
        this.transform = transform;
        this.transform.setParent(parent);
    }

   abstract update(gl: OGLRenderingContext, deltaT: number): void;
   abstract update(gl: OGLRenderingContext, time: number): void;
}
