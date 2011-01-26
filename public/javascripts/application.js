// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function($) {
	// ACTIVATE THE HOVER STATES OF THE IMAGE LINKS
	$("img#add-work-image").mouseenter(function(){
		img_src = $("img#add-work-image").attr('src');
		$("img#add-work-image").attr('src', img_src.replace(/.png/, "-hover.png"));
	}).mouseleave(function(){
		img_src = $("img#add-work-image").attr('src');
		$("img#add-work-image").attr('src', img_src.replace(/-hover.png/, ".png"));
	});
	
	$("a.learn_more img").mouseenter(function(){
		img_src = $("a.learn_more img").attr('src');
		$("a.learn_more img").attr('src', img_src.replace(/.png/, "-hover.png"));
	}).mouseleave(function(){
		img_src = $("a.learn_more img").attr('src');
		$("a.learn_more img").attr('src', img_src.replace(/-hover.png/, ".png"));
	});
	
	// ACTIVATE THE 'ADD YOUR WORK' IMAGE AS A LINK
	$('img#add-work-image').css('cursor', 'pointer');
	$('img#add-work-image').click(function() {
    $('#create-asset-menu').is(":hidden") ? 
      $('#create-asset-menu').show() : $('#create-asset-menu').hide();
    });
});


$(function() {
	// for create asset button at the top
  $("#re-run-action").next().button( {
    text: false,
    icons: { primary: "ui-icon-triangle-1-s" }
  })
  .click(function() {
    $('#create-asset-menu').is(":hidden") ? 
      $('#create-asset-menu').show() : $('#create-asset-menu').hide();
    })
  .parent().buttonset();
	
	if ($('#content_type').val()) {
		the_selected_content_type = $('#content_type').val();
		the_selected_content_type_label = $('#create-asset-menu li[onclick*="' + the_selected_content_type + '"]').html();
		$("#re-run-action").val(the_selected_content_type_label);
		//$('#re-run-action')[0].onclick = function(){ location.href='/assets/new?content_type=' + the_selected_content_type; };		
	}
	
	
  
  $('#create-asset-menu').mouseleave(function(){
    $('#create-asset-menu').hide();
  });

  // for add contributor (in edit article/dataset)
  $("#re-run-add-contributor-action").next().button( {
    text: false,
    icons: { primary: "ui-icon-triangle-1-s" }
  })
  .click(function() {
    $('#add-contributor-menu').is(":hidden") ? 
      $('#add-contributor-menu').show() : $('#add-contributor-menu').hide();
    })
  .parent().buttonset();
  
  $('#add-contributor-menu').mouseleave(function(){
    $('#add-contributor-menu').hide();
  });
});

function createAssetNavigateTo(elem, link) {
  $('#re-run-action')
  .attr('value', $(elem).text())
  .click(function() {
    $('#create-asset-menu').hide();
    location.href = link;
  });

  location.href = link;
}
