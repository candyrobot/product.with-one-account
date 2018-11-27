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

deleteFav = (imageID)->
	$.ajax({
		type:'DELETE',
		url: '/favorites'
		data: {
			imageID: imageID
		}
	})
	.done (a)->
		console.log(a)

window.signup = ->
	dat = {}
	dat.email = $('#component-signup .email').val()
	dat.password = $('#component-signup .password').val()
	return if isInvalid(dat)
	$.post('/users/', dat)
	# TODO sessionがうまく飛ばない 連続postはやはり厳しいか
	login(dat)

window.logout = ->
	$.post('/users/logout')
	setTimeout 'location.reload()', 1000

window.login = (dat = {})->
	dat.email = dat.email || $('#component-login .email').val()
	dat.password = dat.password || $('#component-login .password').val()
	return if isInvalid(dat)
	$.post('/users/login', dat)
	setTimeout 'location.reload()', 1000

isInvalid = (dat)->
	isEmpty(dat) || !isValidEmail(dat.email)

isValidEmail = (email)->
	true

isEmpty = (dat)->
	false

# hoge = ->
# 	$.get('/favorites')
# 	.done (data)->
# 		console.log(data)

window.toggleFav = (el)->
	$(el).toggleClass('true')
	id = $('.fluid').attr('data-imageID');
	if $(el).is('.true')
		$.post('/favorites', { imageID: id });
	else
		deleteFav(id)
	$.get('/images/list', { related: true, imageID: id })
	.done((data)->
		renderRecommendation(data)
	)

renderRecommendation = (data)->
	html = sortByFrequency(data.serialize()).reduce (prev, image)->
		prev + (if image.id == parseInt $('.fluid').attr('data-imageID') then "" else
			"""
			<div style="background-image: url(#{image.url})"></div>
			""")
	, ""
	$('.component-images-horizontal').html(html).show()

sortByFrequency = (array) ->
	frequency = {}
	array.forEach (v) ->
		frequency[v.id] = 0
	uniques = array.filter((v) ->
		++frequency[v.id] == 1
	)
	uniques.sort (a, b) ->
		frequency[b.id] - frequency[a.id]

Array.prototype.removeDuplicate = ()->
	Array.from(new Set(this))

Array.prototype.serialize = ()->
	this.reduce((pre,current)->
		pre.push.apply(pre, current);
		pre
	,[])

appendImages = (images)->
	html = images.reduce (prev, dat)->
		prev + """
		<div class="outer">
			<a
			class="inner" href="/images?imageID=#{dat.id}"
			style="background-image: url(#{dat.url})">
			</a>
			<div class="component-fav" onclick="toggleFav(this)">
				<span>♡</span>
				<span>♥</span>
			</div>
		</div>
		""";
	, ""
	$('#component-images').html(html)

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
