<template>
  <div id="presentation">
    <img id="imgPres" src="../images/boucherie.png"/>
  </div>
</template>

<script>
export default {
  name: 'Presentation'
}
</script>

<style scoped>
  img {
    width: 33vw;
    height: 50vh;
  }
  #presentation {
    height: 100vh;
    background: linear-gradient(0.25turn,#FFF,#bb9a9a);
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
