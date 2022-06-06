<template>
  <header>
    <div>
      <router-link class="link" :to="retourPath"> &#8592; Retour</router-link>
      <router-link class="link" to="/panier">
        <span>Panier</span>
        <div id="chariot">
          <div id="handle"></div>
          <div id="bars">
            <div class="bar"></div>
            <div class="bar"></div>
          </div>
          <div id="panier3"></div>
          <div id="panier1"></div>
          <div id="panier2"></div>
          <div id="rail"></div>
          <div id="wheels">
            <div class="wheel"></div>
            <div class="wheel"></div>
          </div>
        </div>
        ({{panier.length}})
      </router-link>
      <button class="link" @click="toggleFilter">Filtre &nbsp; <img height="100%" src="../images/filter.svg" alt="icone filtrage"></button>
    </div>
    <Filtre @resetFilters="resetFilters" @setNewFilter="setNewFilter" v-if="showFilter"/>
  </header>
</template>

<script>
import Filtre from './Filtre.vue'
import { store } from '../store'
export default {
  name: 'Bandeau',
  components: {
    Filtre
  },
  props: {
    retourPath: String
  },
  data () {
    return {
      showFilter: false,
      panier: store.panier
    }
  },
  methods: {
    /**
     * Summary : Gère l'affichage du filtre.
     */
    toggleFilter () {
      this.showFilter = !this.showFilter
    },
    /**
     * Summary : Transmet le changement de filtre.
     */
    setNewFilter (payload) {
      this.$emit('setNewFilter', payload)
    },
    /**
     * Summary : Transmet la réinitialisation du filtre.
     */
    resetFilters () {
      this.$emit('resetFilters')
    }
  }
}
</script>

<style scoped>
  header {
    border-bottom: 1px solid black;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    padding: 5px 30px;
    position: sticky;
    position: -webkit-sticky;
    top: 0;
    background-color: white;
  }
  .link {
    border: none;
    padding: 3px 9px;
    text-decoration: none;
    color: white;
    background-color: #f04c4c;
    border-radius: 8px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
  }
  button.link {
    height: 25px;
    font-size: 16px;
  }
  .link:hover {
    background-color: #d63b3b;
  }
  img {
    filter: invert(100%) sepia(100%) saturate(0%) hue-rotate(331deg) brightness(101%) contrast(104%);;
  }
  div {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
  }
  #chariot {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  #panier1 {
    width: 11.5px;
    height: 0px;
    background-color: transparent;
    border-top: 3px solid transparent;
    border-left: 0.5px solid transparent;
    border-right: 0.5px solid transparent;
    border-bottom: 1px solid white;
  }
  #panier2 {
    width: 10px;
    height: 0px;
    background-color: transparent;
    border-top: 3px solid transparent;
    border-left: 0.5px solid transparent;
    border-right: 0.5px solid transparent;
    border-bottom: 1px solid white;
  }
  #panier3 {
    width: 13px;
    height: 1px;
    background-color: white;
  }
  #rail {
    width: 13px;
    height: 2px;
    border: 1px solid white;
    border-top-left-radius: 25% 50%;
    border-bottom-left-radius: 25% 50%;
    border-right: none;
    transform: translateX(-1px);
  }
  #wheels {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    width: 25px;
  }
  .wheel {
    background-color: white;
    width: 2px;
    height: 2px;
    border-radius: 50%;
  }
  .bar {
    width: 10px;
    height: 1px;
    background-color: white;
  }
  .bar:nth-of-type(1) {
    transform: rotate(83deg) translateY(3.5px) translateX(3.5px) scaleX(2);
  }
  .bar:nth-of-type(2) {
    transform: rotate(-83deg) translateY(3.5px) translateX(-5px) scaleX(1.5);
  }
  #bars {
    width: 13px;
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
  }
  #handle {
    width: 4px;
    height: 1px;
    transform: rotate(15deg) translateX(-8.5px) translateY(0.5px);
    background-color: white;
    border-radius: 25% 50%;
  }
</style>
