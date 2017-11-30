function loadCss(i){
    var e=document.createElement('link');
    e.type='text/css';
    e.rel='stylesheet';
    e.href=i;
    var s=document.getElementsByTagName('link')[0];
    s.parentNode.insertBefore(e,s);
}
function loadJs(i,a,d){
    var e=document.createElement('script');
    e.type='text/javascript';
    e.async=a;
    e.defer=d;
    e.src=i;
    var s=document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(e,s);
}
function getScrollbarWidth(){
  var outer=document.createElement('div');
  outer.style.visibility='hidden';
  outer.style.width='100px';
  outer.style.msOverflowStyle='scrollbar';
  document.body.appendChild(outer);
  var widthNoScroll=outer.offsetWidth;
  outer.style.overflow='scroll';
  var inner=document.createElement('div');
  inner.style.width='100%';
  outer.appendChild(inner);
  var widthWithScroll=inner.offsetWidth;
  outer.parentNode.removeChild(outer);
  return widthNoScroll-widthWithScroll;
}
function setDesktopDropdownMenu(){
  if(!(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))){
    $('.dropdown').on('mouseenter mouseleave',function(){
      $(this).toggleClass('open');
    });
    $('.dropdown-toggle').removeAttr('data-toggle');
  }
}
function setPricingTablesSameHeight(){
  if($(document).width()>=991){
    if($('#pricing-table-std').height()>$('#pricing-table-pro').height()){
      $('#pricing-table-pro').height($('#pricing-table-std').height());
      $('#pricing-table-pro tbody').height($('#pricing-table-std tbody').height());
    }else{
      $('#pricing-table-std').height($('#pricing-table-pro').height());
      $('#pricing-table-std tbody').height($('#pricing-table-pro tbody').height());
    }
  }else{
    $('#pricing-table-pro').css('height','');
    $('#pricing-table-std').css('height','');
  }
}
$(function(){
  $('body').scrollspy({target:'.navbar','offset-top':160});
  $('.modal').on('show.bs.modal',function(){
    $('.navbar').css('padding-right',getScrollbarWidth());
  });
  $('.modal').on('hidden.bs.modal',function(){
    $('.navbar').css('padding-right','0');
  });
  $('.dropdown open').on('mouseleave',function(e){
    $('.dropdown open').removeClass('open');
  });
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
  // $.getJSON('http://freegeoip.net/json/',function(result){
    // if(result.country_code=='CN'){
      // loadCss('//fonts.useso.com/css?family=Average+Sans');
    // }else{
      // loadCss('//fonts.googleapis.com/css?family=Average+Sans');
    // }
  // });
  setDesktopDropdownMenu();
  setPricingTablesSameHeight();
});
$(window).resize(function(){
  setDesktopDropdownMenu();
  setPricingTablesSameHeight();
});
