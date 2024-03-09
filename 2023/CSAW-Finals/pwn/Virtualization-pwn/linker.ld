ENTRY(main)

SECTIONS {
    . = 0x08048000;
    .data : {
        *(.data)   /* Include data sections from your assembly code */
    }

    .bss : {
        *(.bss)    /* Include uninitialized data sections */
    }

    .text : {
        *(.text)   /* Include text (code) sections from your assembly code */
    }

    .rodata : {
        *(.rodata) /* Include read-only data sections */
    }

    .dynamic : {
        *(.dynamic)
    }

    .got : {
        *(.got)
    }

    .got.plt : {
        *(.got.plt)
    }

    .plt : {
        *(.plt)
    }

    /* Include C library and other required sections */
    /DISCARD/ : {
        *(.eh_frame)
    }
}