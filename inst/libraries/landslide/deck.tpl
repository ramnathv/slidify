<!DOCTYPE html>
<!--
  Copyright 2010 Google Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  Original slides: Marcin Wichary (mwichary@google.com)
  Modifications: Ernest Delgado (ernestd@google.com)
                 Alex Russell (slightlyoff@chromium.org)

  landslide modifications: Adam Zapletal (adamzap@gmail.com)
                           Nicolas Perriault (nperriault@gmail.com)
-->
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <title>{{ title }}</title>
    <meta name="description" content="{{title}}">
    <meta name="author" content="{{author}}">
    <meta name="generator" content="slidify" />
    
    <!-- Styles -->
    
    <link href="{{lib_path}}/landslide/themes/{{theme}}/css/print.css" 
       rel="stylesheet" media="print" >
    <link href="{{lib_path}}/landslide/themes/{{theme}}/css/screen.css" 
       rel="stylesheet" media="screen, projection" >
    {{> user_css }}
    <link href = "{{lib_path}}/{{highlighter}}/styles/{{histyle}}.css"
       rel="stylesheet">
       
    <!-- /Styles -->
    <!-- Javascripts -->
    
    <script type="text/javascript" 
      src ="{{lib_path}}/landslide/themes/{{theme}}/js/slides.js">
    </script>
    
    <!-- /Javascripts -->
</head>    
<body>
  <div id="blank"></div>
  <div class="presentation">
    <div id="current_presenter_notes">
      <div id="presenter_note"></div>
    </div>
    <div class="slides">
    {{#slides}}
      <div class="slide-wrapper">
        <div class="slide{{#classes}} {{.}}{{/classes}}">
          {{{ slide }}}
        </div>
      </div>
    {{/slides}}
    </div>
  </div>
  
  <div id="toc" class="sidebar hidden">
     <h2>Table of Contents</h2>
     <table>
       <caption>Table of Contents</caption>

       {{#slides}}
       <tr id="toc-row-{{ num }}" {{#sub}}class = "sub" {{/sub}}>
         <th><a href="#slide{{ num }}">{{{ title }}}</a></th>
         <td><a href="#slide{{ num }}">{{ num }}</a></td>
       </tr>
       {{/slides}}
     </table>
  </div>
  
  {{> landslide_help }}
</body>
  <script>main()</script>
  {{> mathjax}}
  {{> highlight_js}}
  <script src="http://www.w3resource.com/twitter-bootstrap/twitter-bootstrap-v2/docs/assets/js/jquery.js"></script>
  <script src="http://www.w3resource.com/twitter-bootstrap/twitter-bootstrap-v2/js/bootstrap-modal.js"></script>
</html>

