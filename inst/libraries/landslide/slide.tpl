<div class="inner">
  <header>{{{ header }}}</header>
  {{#content}}
  <section>
    {{{ . }}}
  </section>
  {{/content}}
</div>
<div class="presenter_notes">
  <header><h1>Presenter Notes</h1></header>
  {{# pnotes}}
  <section>
    {{{ . }}}
  </section>
  {{/ pnotes}}
</div>

<div class="modal hide" id="source-{{ num }}" style='display:none'>
  <div class="modal-body">
  <pre><code>
{{ raw }}
  </code></pre>
  </div>
  <div class="modal-footer">
    <a href="#" class="btn" data-dismiss="modal">Close</a>
    <a href="#" class="btn btn-primary">Save changes</a>
  </div>
</div>

<footer>
  <aside class="source">
    <a class="btn" data-toggle="modal" href="#source-{{ num }}">
      View Source
    </a>
  </aside>
  <aside class="page_number">
    {{ num }} / {{ num_slides }}
  </aside>
</footer>
