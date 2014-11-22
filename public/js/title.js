$(function(){
	$(".title_iron img").animate(
	    {marginTop: "0px"},
	    1000
  );

	$(".link").hover(function(){
			$(this).fadeTo(200, 0.6);
		},
		function(){
			$(this).fadeTo(200, 1.0);
		}
	);

  });