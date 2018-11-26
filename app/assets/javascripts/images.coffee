# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeApp = ->
	$.get('/application', (dat)->
		console.log(dat)
		appendImages dat.images
		if dat.session.userID
			$('#component-actions .login').hide();
	)

window.signup = ->
	dat = {}
	dat.email = $('.component-input .email').val()
	dat.password = $('.component-input .password').val()
	return if isInvalid(dat)
	$.post('/users/', dat)

window.logout = ->
	$.post('/users/logout')
	setTimeout 'location.reload()', 1000

window.login = ->
	dat = {}
	dat.email = 'findwkwk@gmail.com'#$('.component-input .email').val()
	dat.password = 'I12rk040'#$('.component-input .password').val()
	return if isInvalid(dat)
	$.post('/users/login', dat)
	setTimeout 'location.reload()', 1000

isInvalid = (dat)->
	isEmpty(dat) || !isValidEmail(dat.email)

isValidEmail = (email)->
	true

isEmpty = (dat)->
	false

window.displayInput = ->
	$('.component-input button').text('ログイン');
	$('.component-input button').attr('onclick', 'login();');
	$('.component-input').show();

appendImages = (images)->
	images.map((dat)->
		html = """
		<div class="outer">
			<div style="background-image: url(#{dat.url})"></div>
		</div>
		""";
		$(html).appendTo('#component-images');
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
