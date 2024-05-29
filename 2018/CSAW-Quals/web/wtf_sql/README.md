# WTF.SQL

Description: (see crawl.txt)
Points: 500
Category: Web
Flag: `flag{b3tter_th@n_th3_prequels}`

Solve:
1. robots.txt -> find all routes
1. use verifier route to leak source for all routes, subroutines
1. Template injection
    * can't use `${config_signing_key}` in post directly since it's blacklisted
    * recursive template expansion allows use of `${GET_asdf}`
    * if `?asdf=${config_signing_key}` then it will get interpolated again leaking secret
1. secret is used to sign cookies
1. allows you to change `is_admin`
1. get to admin panel, need to add privileges
1. HLE to add `panel_view` and `panel_create` privs, giving you arbitrary db.table read
1. ggwp

Formatting notes:
    * Types
        * Routes should be VARCHAR(255)
        * header, cookie, template, etc. keys should be VARCHAR(255)
        * header, cookie, template, etc. values should be TEXT
        * response is TEXT
    * Naming
        * k/v pairs are always `name` `value` (to add to the confusion)
