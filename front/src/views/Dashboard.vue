<template>
  <div id="dashboard">
    <Sidebar @changePage="changePage" />
    <div id="content">
      <Commandes v-if="page === 'commandes'"/>
      <ComptesManager v-else-if="page === 'comptes'"/>
      <ProduitsManager v-else-if="page === 'produits'"/>
    </div>
  </div>
</template>

<script>
import Sidebar from '../components/Sidebar.vue'
import Commandes from '../components/Commandes.vue'
import ComptesManager from '../components/ComptesManager.vue'
import ProduitsManager from '../components/ProduitsManager.vue'
export default {
  name: 'Dashboard',
  components: {
    Sidebar,
    Commandes,
    ComptesManager,
    ProduitsManager
  },
  data () {
    return {
      page: 'commandes'
    }
  },
  methods: {
    /**
     * Summary : Change la page du dashboard.
     * Description : Appelé par composant enfant.
     * @param {String} - Nom de la page indiqué par composant enfant
     */
    changePage (page) {
      this.page = page
    }
  }
}
</script>

<style scoped>
  #dashboard {
    width: 100vw;
    display: flex;
    flex-direction: row;
    justify-content: center;
  }
  #content {
    width: 80vw;
  }
</style>
