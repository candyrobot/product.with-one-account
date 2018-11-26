# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.signup = ->
	dat = {}
	dat.email = $('.component-input .email').val()
	dat.password = $('.component-input .password').val()
	return if isInvalid(dat)
	$.post('/users/', dat)

window.signin = ->
	dat = {}
	dat.email = 'findwkwk@gmail.com'#$('.component-input .email').val()
	dat.password = 'I12rk040'#$('.component-input .password').val()
	return if isInvalid(dat)
	console.log(dat.email);
	console.log(dat.password);
	$.post('/users/start_session', dat)

isInvalid = (dat)->
	isEmpty(dat) || !isValidEmail(dat.email)

isValidEmail = (email)->
	true

isEmpty = (dat)->
	false

window.displayInput = ->
	$('.component-input button').text('ログイン');
	$('.component-input button').attr('onclick', 'signin();');
	$('.component-input').show();

window.appendImages = ->
	$.get('/images/index', (a)->
		console.log(a);
		a.map((dat)->
			html = """
			<div class="outer">
				<div style="background-image: url(#{dat.url})"></div>
			</div>
			""";
			$(html).appendTo('#component-images');
		);
	);

post = ->
	url = $('#component-post input').val();
	if(isValidUrl(url))
		$.post('/images/', { url: url });

isValidUrl = (url)->
	url.indexOf('.jpg') != -1 ||
	url.indexOf('.jpeg') != -1 ||
	url.indexOf('.png') != -1 ||
	url.indexOf('.gif') != -1 ||
	url.indexOf('.JPG') != -1 ||
	url.indexOf('.JPEG') != -1 ||
	url.indexOf('.PNG') != -1 ||
	url.indexOf('.GIF') != -1
