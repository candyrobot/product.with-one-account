# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.initializeApp = ->
	$.get('/application'+location.search, (dat)->
		console.log(dat)
		window.dat = dat
		if dat.session.userID
			$('#component-actions .login').hide()
			$('#component-actions .signup').hide()
		else
			$('#component-actions .mypage').hide()
			$('#component-actions .favorite').hide()
			$('.component-images-horizontal').on 'click', 'a', ->
				toast 'ログインすると見れます。　最高のエロ画像を探そう!🌟'
				return false

		if location.search.indexOf('imageID') != -1
			renderImage(dat.images[0])
			imageID = dat.images[0].id
			b = !!window.dat.favorites.filter((fav)-> imageID == parseInt fav.imageID ).length
			$('.row').html("""
			""" + (if countUp('x') > 3 then "" else """
			<div class="balloon">
				タップして "お気入り" に入れると…　👉
			</div>""") + """
			<div class="fav-area" onclick="$(this).prev().hide()">#{getHtmlFav(b)}</div>
			""")
			.find('.component-fav').on 'click', ()->
				if $(this).is('.true')
					deleteFav(imageID)
					.done => $(this).removeClass('true')
				else
					$.post('/favorites', { imageID: imageID })
					.fail (dat)-> toast(dat.responseJSON.toast)
					.done => $(this).addClass('true')
				$.get('/images/list', { related: true, imageID: imageID })
				.done renderRecommendation
		else
			renderImages()

		$('#component-logout h1').text(window.dat.session.userID)
		$('#component-logout h5').text(window.dat.session.email)
	)

deleteFav = (imageID)->
	$.ajax({
		type:'DELETE',
		url: '/favorites'
		data: {
			imageID: imageID
		}
	})
	.fail (dat)-> toast(dat.responseJSON.toast)

window.signup = ->
	dat = {}
	dat.email = $('#component-login .email').val()
	dat.password = $('#component-login .password').val()
	return if isInvalid(dat)
	$.post('/users/', dat)
	.fail (dat)-> toast(dat.responseJSON.toast)
	.done ->
		# TODO sessionがうまく飛ばない? 連続postはやはり厳しいか
		login(dat)

window.logout = ->
	$.post('/users/logout')
	.fail (dat)-> toast(dat.responseJSON.toast)
	.done -> setTimeout 'location.reload()', 1000

window.login = (dat = {})->
	dat.email = dat.email || $('#component-login .email').val()
	dat.password = dat.password || $('#component-login .password').val()
	return if isInvalid(dat)
	$.post('/users/login', dat)
	.fail (dat)-> toast(dat.responseJSON.toast)
	.done -> setTimeout 'location.reload()', 1000

isInvalid = (dat)->
	isEmpty(dat) || !isValidEmail(dat.email)

isValidEmail = (email)->
	true

isEmpty = (dat)->
	false

isShouldNotRender = (image)->
	image.id == parseInt($('.fluid').attr('data-imageID')) ||
	window.dat.favorites.filter((fav)-> parseInt(fav.imageID) == image.id).length

renderRecommendation = (images)->
	html = sortByFrequency(images.serialize()).reduce (prev, image)->
		prev + (if isShouldNotRender(image) then "" else
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
	html = window.dat.images.reduce (prev, dat, i)->
		s = getHtmlFav(!!window.dat.favorites.filter((fav)-> dat.id == parseInt fav.imageID ).length);
		t = if i % 12 then "" else """<div class="message">
			スマホのホーム画面にこのアプリを追加することができるのです
			<i>(ここをタップ)</i>
		</div>"""
		prev + """
		#{t}
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
		# $(this).toggleClass('true')
		imageID = $(this).closest('.outer').data('imageid')
		if $(this).is('.true')
			deleteFav(imageID)
			.done => $(this).removeClass('true')
		else
			$.post('/favorites', { imageID: imageID })
			.fail (dat)-> toast(dat.responseJSON.toast)
			.done => $(this).addClass('true')
	$('#component-images')
	.find('.message').on 'click', ->
		showWebview('https://teratail.com/questions/43453')
renderImage = (image)->
	html = """
	<div class="fluid" data-imageID="#{image.id}">
		<img src="#{image.url}">
	</div>
	""";
	$('#component-images').html(html);

window.post = ->
	url = $('#component-post input').val();
	$.post('/images/', { url: url })
	.fail (dat)-> toast(dat.responseJSON.toast)
	.done -> setTimeout 'location.reload()', 1000

toast = (txt)->
	return if !txt
	$("""
	<div>#{txt}</div>
	""").appendTo('#layer-asAlert')
	.hide()
	.show(300, ()->
		setTimeout ()=>
			$(this).hide(300)
		, 2000
	)

countUp = (key)->
	a = []
	a[key] = JSON.parse localStorage.getItem(key)
	a[key] = 0 if a[key] == null
	localStorage.setItem(key, JSON.stringify(++a[key]))
	a[key]

showWebview = (url)->
	$('#webview').fadeIn(400)
	$('#webview iframe').attr('src', url)
	$('#webview iframe').animate({
		top: 0
	}, 500)
	$('#webview .close').on 'click', ->
		$('#webview iframe').removeAttr('style')
		$('#webview iframe').removeAttr('src')