<!--
Google IO 2012 HTML5 Slide Template

Authors: Eric Bidelman <ebidel@gmail.com>
         Luke Mahe <lukem@google.com>

URL: https://code.google.com/p/io-2012-slides
-->
<!DOCTYPE html>
<html>
<head>
  <title>{{ title }}</title>
  <meta name="description" content="{{title}}">
  <meta name="author" content="{{author}}">
  <meta name="generator" content="slidify" />
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="chrome=1">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <link rel="stylesheet" media="all" href="{{lib_path}}/io2012/css/default.css">
   <link rel="stylesheet" media="only screen and (max-device-width: 480px)" href="{{lib_path}}/io2012/css/phone.css">
   <link rel="stylesheet" href="{{lib_path}}/{{highlighter}}/styles/{{histyle}}.css">
   {{> user_css}}
  <base target="_blank"> <!-- This amazingness opens all links in a new tab. -->
  <script data-main="{{lib_path}}/io2012/js/slides" src="{{lib_path}}/io2012/js/require-1.0.8.min.js"></script>
</head>
<body style="opacity: 0">

<slides class="layout-widescreen">

<slide class="title-slide segue nobackground">
  <aside class="gdbar"><img src="images/google_developers_icon_128.png"></aside>
  <hgroup class="auto-fadein">
    <h1>{{ title }}</h1>
    <p>{{ author }}</p>
  </hgroup>
</slide>

{{# slides}}
<slide class="{{ classes }}" id = "{{ id }}">
  {{{ slide }}}
</slide>
{{/ slides}}

<slide class="backdrop"></slide>

</slides>

<!--[if IE]>
  <script src="http://ajax.googleapis.com/ajax/libs/chrome-frame/1/CFInstall.min.js"></script>
  <script>CFInstall.check({mode: 'overlay'});</script>
<![endif]-->
</body>
{{> mathjax}}
{{> highlight_js}}
{{> google_prettify}}
{{> user_js}}
</html>
