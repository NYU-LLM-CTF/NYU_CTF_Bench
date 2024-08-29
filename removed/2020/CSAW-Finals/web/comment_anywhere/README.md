# Comment Anywhere

Web 300ish
Description:

```
This is a cool new Chrome extension i'm working on which lets you leave a comment anywhere on any page that others using the extension can see. Check it out!

NOTE: It should go without saying, but please don't install this in a chromium installation you care about.
```

## Deployment

* ~Update URL and that server will be deployed to in `extension/background.js` (the api config value)~
* ~`./build-all.sh`~
* `./build-docker.sh`
* `./reset.sh`


## Notes

* The chal can basically only be solved by 1 team at a time because the admin bot can only point to 1 API at a time. If they've tested locally tho and it works, they should be able to set the API and have the flag within a few seconds and then the next team can come along after the DB reset (every 2 mins).


## Solution Guide

* Grab crx, extract, begin to look around
* See API, lack of sanitization, innerHTML setting
* Leak all comments by abusing the regex to find which page the admin is on
* Discover you can call the `setConfig` handler because of bad splat'ing in inject.js overriding `type` and the proxying through inject.js satisfying the sender.id requirement
* overwrite the API endpoint to something you control
* this effectively leaks the browsing activity of the admin. flag is in one of the URLs they visit.
