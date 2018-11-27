# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeApp = ->
	$.get('/application'+location.search, (dat)->
		console.log(dat)
		window.dat = dat
		if dat.images.length == 1
			renderImage(dat.images[0])
		else
			renderImages()
		if dat.session.userID
			$('#component-actions .login').hide();
		if location.search.indexOf('imageID') != -1
			imageID = dat.images[0].id
			b = !!window.dat.favorites.filter((fav)-> imageID == parseInt fav.imageID ).length
			$('.fav-area').html(getHtmlFav(b))
			.find('.component-fav').on 'click', ()->
				$(this).toggleClass('true')
				if $(this).is('.true')
					$.post('/favorites', { imageID: imageID });
					$.get('/images/list', { related: true, imageID: imageID })
					.done renderRecommendation
				else
					deleteFav(imageID)
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

renderRecommendation = (data)->
	html = sortByFrequency(data.serialize()).reduce (prev, image)->
		prev + (if image.id == parseInt $('.fluid').attr('data-imageID') then "" else
			"""
			<a
			href="/images?imageID=#{image.id}"
			style="background-image: url(#{image.url})"></a>
			""")
	, ""
	return if !html
	$('.component-images-horizontal').html(html)
	.closest('.area-recommendation').show(300)

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

getHtmlFav = (isTrue)->
	"""
	<div class="component-fav #{isTrue}">
		<span>♡</span>
		<span>♥</span>
	</div>
	"""

renderImages = ()->
	html = window.dat.images.reduce (prev, dat)->
		s = getHtmlFav(!!window.dat.favorites.filter((fav)-> dat.id == parseInt fav.imageID ).length);
		prev + """
		<div class="outer" data-imageID="#{dat.id}">
			<a
			class="inner" href="/images?imageID=#{dat.id}"
			style="background-image: url(#{dat.url})">
			</a>
			#{s}
		</div>
		""";
	, ""
	$('#component-images').html(html)
	.find('.component-fav').on 'click', ()->
		$(this).toggleClass('true')
		imageID = $(this).closest('.outer').data('imageid')
		console.log(imageID)
		if $(this).is('.true')
			$.post('/favorites', { imageID: imageID });
		else
			deleteFav(imageID)

renderImage = (image)->
	html = """
	<div class="fluid" data-imageID="#{image.id}">
		<img src="#{image.url}">
	</div>
	""";
	$('#component-images').html(html);

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
