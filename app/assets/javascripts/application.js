// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function generate_new_form(){
	$('.form_div:first').clone().insertAfter('.form_div:last')
}

$(document).ready(function() {

	
	$('.new_tweeter').click(function(event){
		event.preventDefault();
		// $('form div:hatch_form').append('.form_div');
		if ($('.form_div').length < 9){
			generate_new_form();
		}
		else{
			alert("Your flock is full. Get flocking!");
		}
	});

	// $('.flock_create').click(function(event){
	// 	event.preventDefault();
	// 	// console.log(tweeters);
	// 	$.ajax({
	//   		url:'Flocker::Email.set_handles',
	//   		data: :tweeters,
	//   		type: "POST"
	//   		// success: //load the new page,
	//   		// error: function(xhr,status){
	//   		// $('#order_form').html("<h2>Sorry, there was an error sending your order to the server, no pun intended.<h2>");
	//   		// }	
 //  		});
	// });

})