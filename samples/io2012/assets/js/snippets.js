$(document).ready(function() {
  // hide all solutions initially
  $('div.solution').hide()
});  
$("button").click(function(){
  $(this).siblings("div.solution").toggle()
  // $(this).parents().find("div.solution").toggle()
  
});
$('.mcq ol').click(function(){
  $(this).find('li em').css({"color":"green", "font-weight":"bolder"});
  $(this).find('li:not("em")').css({"color":"#ddd"}) 
})
