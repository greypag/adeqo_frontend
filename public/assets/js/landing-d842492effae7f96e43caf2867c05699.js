$(document).ready(function(){
  $('body').scrollspy({target:'.navbar','offset-top':120});
  $('.scroll-container a').on('click',function(e){
    if(this.hash!==''){
      e.preventDefault();
      var hash=this.hash;
      $('html,body').animate({
        scrollTop:$(hash).offset().top
      },800,function(){
        window.location.hash=hash;
      });
    }
  });
  if(!(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))){
    $('.dropdown').on('mouseenter mouseleave click tap',function(){
      $(this).toggleClass('open');
    });
    $('.dropdown-toggle').removeAttr('data-toggle');
  }
});
