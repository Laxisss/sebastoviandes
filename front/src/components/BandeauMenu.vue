<template>
  <header>
    <router-link v-if="sessionStorage.getItem('id') === null" class="link" to="/login">S'inscrire / Se connecter</router-link>
    <div v-else>
      <span>Bonjour {{ sessionStorage.getItem('prenom') }}&nbsp;</span>
      <router-link to="/dashboard" v-if="sessionStorage.getItem('isAdmin') === 1" class="link">Dashboard</router-link>
      <button class="link" @click="disconnect">Déconnexion</button>
    </div>
  </header>
</template>

<script>
import { store } from '../store'
export default {
  name: 'BandeauMenu',
  data () {
    return {
      dataStore: store
    }
  },
  methods: {
    /**
     * Summary : Réinitialise les variables de session.
     */
    disconnect () {
      sessionStorage.clear()
    }
  }
}
</script>

<style scoped>
  header {
    border-bottom: 1px solid black;
    width: calc(100vw - 60px);
    padding: 5px 30px;
    position: absolute;
    top: 0;
    background-color: transparent;
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
  }
  span {
    color: white;
    font-weight: 600;
  }
  .link {
    border: none;
    padding: 3px 9px;
    text-decoration: none;
    color: white;
    background-color: #f04c4c;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
  }
  .link:hover {
    background-color: #d63b3b;
  }
</style>
