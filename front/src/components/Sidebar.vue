<template>
  <div id="sidebar">
    <h1>Sebastoviandes</h1>
    <div id="option">
      <ul>
        <li @click="changePage('commandes')">
          Commandes
        </li>
        <!--
        <ul v-if="page === 'commandes'">
          <li>Commandes actuelles</li>
          <li>Commandes passées</li>
        </ul>
        -->
        <li @click="changePage('comptes')">Comptes</li>
        <li @click="changePage('produits')">Produits</li>
      </ul>
      <router-link class="link" to="/">Menu</router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Sidebar',
  data () {
    return {
      page: 'commandes'
    }
  },
  methods: {
    /**
     * Summary : Change la page du dashboard.
     * Description : Emet l'évènement changePage au composant parent.
     * @param {String} - Nom de la page
     */
    changePage (page) {
      this.page = page
      this.$emit('changePage', page)
    }
  }
}
</script>

<style scoped>
  #option {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: flex-start;
    height: 80%;
  }
  ul {
    text-align: left;
    list-style-type: none;
  }
  li:hover {
    background-color: rgb(184, 14, 14);
    cursor: pointer;
  }
  li {
    padding: 10px;
    font-weight: 600;
    border-radius: 8px;
    width: 100%;
  }
  .link {
    border: none;
    padding: 3px 9px;
    text-decoration: none;
    color: white;
    background-color: rgb(223, 34, 34);
    cursor: pointer;
    font-weight: 600;
  }
  .link:hover {
    background-color: rgb(184, 14, 14);
  }
  #sidebar {
    background-color: rgb(223, 34, 34);
    color: white;
    min-width: 20vw;
    position: sticky;
    position: -webkit-sticky;
    top: 0;
    height: 100vh;
    overflow: hidden;
  }
</style>
