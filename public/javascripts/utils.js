function update_listed_price(mrp,acp,id,element) {

 // alert("aaya");
    jQuery('.product-listing span#'+id+'acp').text('Our Price: Rs.' + acp);
    jQuery('.product-listing span#'+id+'mrp').html('<del>MRP: Rs.'+mrp+'</del>');

    colourFade('.product-listing span#'+id+'mrp','#c9de55', 400, 400);
    colourFade('.product-listing span#'+id+'acp','#c9de55', 400, 400);
    //ColourFade('.product-listing li#product_'+id +' div.product-title', 'Yellow');


  }

function update_cart(name) {
    //alert(name);
    //setTimeout("ColourFade('#omnicart-list', '#c9de55')", 2600);
    //$.('#omnicart-list').html($.('#omnicart-list').html+'<li>'+ name + '</li>');
    colourFade('#omnicart-list', '#c9de55', 500,10000);
}

function colourFade(selector,color, time1, time2){
   // alert("aaya");
    jQuery(selector)
        .css('opacity', 1)
        .animate({ backgroundColor: color, opacity: 1.0 }, time1)
        .animate({ backgroundColor: '#ffffff', opacity: 1.0}, time2 );
}