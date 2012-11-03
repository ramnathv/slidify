$(document).ready(function () {
  $('ul.nav > li').click(function (e) {
   
    $('ul.nav > li').removeClass('active');
    $(this).addClass('active');                
  });            
});


$('body').delegate('.nav li a', 'click', function(){
    var $thisLi = $(this).parents('li:first');
    var $ul = $thisLi.parents('ul:first');
    if (!$thisLi.hasClass('active')){
        $ul.find('li.active').removeClass('active');
        $thisLi.addClass('active');
    }
});