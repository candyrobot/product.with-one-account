<template>
  <div class="component-fav" :class="{ isFill: isFill }">
    <div v-if="isOn" class="isOn">
      <div>♥</div>
    </div>
    <div v-else="isOn">
      <div>♡</div>
    </div>
    <!-- <div>text</div> -->
  </div>
</template>

<script>
export default {
  props: [
    'isOn',
    'isFill'
  ],
  methods: {

  }
}
</script>

<style scoped>

.component-fav > div {
  color: #888;
  text-align: center;
  border-radius: 100%;
}

.component-fav .isOn {
  color: #ff7878;
}

.isFill {
  background: red;
}

</style>
