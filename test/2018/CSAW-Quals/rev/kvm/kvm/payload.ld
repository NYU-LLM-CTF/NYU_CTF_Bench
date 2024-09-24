SECTIONS
{
        .payload 0 : {
                guest = .;
                guest.o
                guest_end = .;
        }
}
