This file describes any changes made to the challenge that may be relevant to its difficulty or solution.

# Changes

## Sanitizer API Deprecation

The original challenge depends on the [setHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/setHTML) API, which was removed from [Chrome starting in version 119](https://developer.chrome.com/blog/sanitizer-api-deprecation). Its use in [`web/index.html`](./web/index.html) has been replaced with [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML) API, but this makes the challenge significantly easier to solve, since the use of `setHTML` was intended to force the player to use inline CSS styles to leak the flag:

> The CSP allows for style tags for CSS injection, and .setHTML (html sanitizer API) also allows inline styles, but the rainbowify() function messes up any styles we try to insert...

An alternative might be to use Mozilla's [Sanitizer Polyfill](https://github.com/mozilla/sanitizer-polyfill), but I couldn't get it to work (and I'm not sure the behavior is identical to the original API). Maybe also ask the challenge author (`arxenix`) what their preferred alternative is.
