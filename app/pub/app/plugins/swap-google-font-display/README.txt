=== Swap Google Fonts Display ===
Contributors: gijo
Donate link: https://www.paypal.me/gijo
Tags: fonts, google fonts, web font
Requires at least: 3.0.1
Tested up to: 5.2
Stable tag: 1.0
License: GPLv2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html

Inject font-display: swap to Google Fonts to ensure text remains visible during webfont load

=== How it works ===

Swap Google Fonts Display plugin will find all Google Fonts in a webpage and set its font-display to swap

By default browser will wait until the Google Fonts are downloaded to display the font. This is the reason for the error **'ensure text remains visible during webfont load'** in [Google PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)

Luckly Google Fonts now supports setting `font-display` via a new query parameter. By setting `front-display` to swap, the browser is use the fallback font and when downloading actuall font is complete, it just swap the font!

=== Note ===
Plugin can't add `font-display: swap` to dynamically (via JS) injected Google Fonts

If you want more tips on optimizing WordPress for speed, checkout my blog - [WP Speed Matters](http://wpspeedmatters.com/)  

== Installation ==

Just install the plugin and active it. No further configuration is need

== Changelog ==

= 1.0 =
* First release!