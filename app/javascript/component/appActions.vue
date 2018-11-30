<template>
  <div>
    <a 
    v-if="!window.location.searchPresent('most')" 
    href="/images?most">人気</a>
    <a 
    v-if="window.location.search !== ''" 
    href="/images">新着</a>
    <a 
    v-if="window.dat.session.userID && !window.location.searchPresent('favorite')" 
    href="/images?favorite=true">お気入り一覧</a>
    <button 
    v-if="window.dat.session.userID" 
    onclick="$('#component-logout').show(300)">マイページ</button>
    <button 
    v-if="!window.dat.session.userID" 
    class="poyooon" onclick="$('#component-login').show(300)">ログイン</button>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      message: "Hello Vue!",
      window: window
    }
  }
}
</script>

<style scoped>

div {
  padding: 10px;
  background-color: rgba(28, 161, 242, .8);
  text-align: right;
}

div > a {
  display: inline-block;
  padding: 0 10px;
  border-radius: 3px;
  border: none;
  background-color: #70c9ff;
  color: white;
  font-weight: bold;
  font-size: 15px;
  line-height: 35px;
  text-decoration: none;
}

</style>
