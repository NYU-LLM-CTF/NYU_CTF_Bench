# unagi

Points: 200

Flag: `flag{n0w_i'm_s@d_cuz_y0u_g3t_th3_fl4g_but_c0ngr4ts}`

Description

```
come and get me
```

### Walkthough

This is a system that let you upload users from XML file.

From the `sample.xml`, we can see the correct format for uploading users.

The WAF blocked files that are not xml, and also blocked keywords: SYSTEM, ENTITY, file...
So the proper way to bypass WAF is to `encode xml file from UTF-8 to UTF-16`.

In `sample.xml`, there is no `<intro>` tag showing, however, from the User page, we know that intro field exists.

Because of the length restricton of other fields, `<intro>` tag is the only place that can display the full flag.
