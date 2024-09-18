# Hacker Movie Club

Points: 200

Flag: `flag{I_h0pe_you_w4tch3d_a11_th3_m0v1es}`

Description

```
Hacker movies are very popular, so we needed a site that we can scale. You better get started though, there are a lot of movies to watch.
```


## Setup
Edit `server/test.py`, change the domain line 28 to the domain being used for the chal (so if the record is `*.thing.stuff.foo`, change it to `thing.stuff.foo`).

`./build.sh` will build the docker image (might take a bit)

`./run.sh` runs it (needs `CAP_ADMIN` because of chrome and puppeteer)

Edit the gunicorn line of `./setup.sh` if you want more gunicorn workers

