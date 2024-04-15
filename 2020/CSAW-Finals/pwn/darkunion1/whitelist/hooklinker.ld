SECTIONS
{
    .hooks : {
        PROVIDE(__start_hooks = .);
        *(.hooks)
        PROVIDE(__stop_hooks = .);
    }
}
INSERT AFTER .text
