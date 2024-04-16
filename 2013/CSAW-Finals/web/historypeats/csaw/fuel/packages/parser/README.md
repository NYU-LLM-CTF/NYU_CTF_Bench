# Parser package

## Installing

Simply add `parser` to your config.php `always_loaded.packages` config option.

## Included Parsers

* Markdown - A PHP version of Markdown by Michel Fortin.

## Usage

```php
// old usage still valid, will load app/views/example.php
View::forge('example');

// load a SimpleTags template, will load and parse app/views/example.stags
View::forge('example.stags');

// load a Mustache template, will load and parse app/views/example.mustache
View::forge('example.mustache');

// load a Twig template, will load and parse app/views/example.twig
View::forge('example.twig');

// load a Hybrid Haml / Twig template, ATTENTION: this one expects app/views/example.twig and {% haml %} code at the top of the view
View::forge('example.mthaml');

// load a Jade template, will load and parse app/views/example.jade
View::forge('example.jade');

// load a Haml template, will load and parse app/views/example.haml
View::forge('example.haml');

// load a Smarty template, will load and parse app/views/example.smarty
View::forge('example.smarty');

// load a Dwoo template, ATTENTION: this one expects app/views/example.tpl
View::forge('example.dwoo');
```

## Installing parsers

Only Markdown is included. While many other drivers are included, their libraries are not and are by default.

Mustache, Twig, MtHaml and Smarty should be installed via Composer. Simply add the libraries to your project's `composer.json` then run `php composer.phar install`:

```json
{
    "require": {
        "mustache/mustache" : "*",
        "smarty/smarty" : "*",
        "twig/twig" : "*",
        "mthaml/mthaml": "*"
    }
}
```

Other libraries are expected in `app/vendor/lib_name` (capitalize lib_name), you'll have to download them yourself. Don't change the casing or anything, keep it as much original as possible within the `vendor/lib_name` dir to keep updating easy (also because some come with their own autoloader).

You can configure them to be loaded from other locations by copying the parser.php config file to your app and editing it.

## Config and runtime config

Currently the drivers still lack a lot of config options they should probably accept. They are currently all configured to work with one instance of their parser library, which is available to config:

```php
$view = View::forge('example.stags');
$view->parser()->set_delimiters('{', '}');
```
