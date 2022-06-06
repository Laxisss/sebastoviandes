<template>
  <div>
    <BandeauMenu/>
    <div class="home">
      <Presentation/>
      <Info/>
      <CandC/>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
// import axios from 'axios'
import Presentation from '../components/Presentation.vue'
import Info from '../components/Info.vue'
import CandC from '../components/CandC.vue'
import BandeauMenu from '../components/BandeauMenu.vue'

export default {
  name: 'Home',
  components: {
    Presentation,
    Info,
    CandC,
    BandeauMenu
  }
}
</script>

<style scoped>
  .home {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
  }
</style>
