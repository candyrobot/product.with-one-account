# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeApp = ->
	$.get('/application'+location.search, (dat)->
		console.log(dat)
		if dat.images.length == 1
			appendImage(dat.images[0])
		else
			appendImages dat.images
		if dat.session.userID
			$('#component-actions .login').hide();
	)

window.signup = ->
	dat = {}
	dat.email = $('#component-signup .email').val()
	dat.password = $('#component-signup .password').val()
	return if isInvalid(dat)
	$.post('/users/', dat)

window.logout = ->
	$.post('/users/logout')
	setTimeout 'location.reload()', 1000

window.login = ->
	dat = {}
	dat.email = $('#component-login .email').val()
	dat.password = 'I12rk040'#$('#component-login .password').val()
	return if isInvalid(dat)
	$.post('/users/login', dat)
	setTimeout 'location.reload()', 1000

isInvalid = (dat)->
	isEmpty(dat) || !isValidEmail(dat.email)

isValidEmail = (email)->
	true

isEmpty = (dat)->
	false

window.toggleFav = (el)->
	$(el).toggleClass('true')
	id = $('.fluid').attr('data-imageID');
	$.post('/favorites', { imageID: id });

appendImages = (images)->
	images.map((dat)->
		html = """
		<a class="outer" href="/images?imageID=#{dat.id}">
			<div style="background-image: url(#{dat.url})"></div>
		</a>
		""";
		$(html).appendTo('#component-images');
	);

appendImage = (image)->
	html = """
	<div class="fluid" data-imageID="#{image.id}">
		<img src="#{image.url}">
	</div>
	""";
	$(html).appendTo('#component-images');

window.post = ->
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
