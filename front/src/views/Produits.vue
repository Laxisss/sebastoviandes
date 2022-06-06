<template>
  <div class="products">
    <img src="../images/peppa.png"/>
    <Bandeau @resetFilters="resetFilters" @setNewFilter="setNewFilter" :retourPath="'/'"/>
    <div id="products-list" v-if="produits">
      <Produit v-for="item in produits.length" :key="item" @addToCart="addToCart" :id="Number(produits[item - 1].ID_Produit)" :nom="produits[item - 1].Libelle" :prix="produits[item - 1].Prix + '€'" :unite="produits[item - 1].Unite" :lienPhoto="produits[item - 1].Lien_Photo" :uniteComm="produits[item - 1].UniteComm" :grammage="Number(produits[item - 1].Grammage)" :parPers="produits[item - 1].echellons" />
    </div>
    <div v-else>
      <h1>Aucun produit ne correspond à ces critères</h1>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import { store } from '../store'
import axios from 'axios'
import Produit from '../components/Produit.vue'
import Bandeau from '../components/Bandeau.vue'

export default {
  name: 'Produits',
  components: {
    Produit,
    Bandeau
  },
  data () {
    return {
      produits: [],
      dataStore: store,
      baseURL: store.baseURL
    }
  },
  methods: {
    /**
     * Summary : Ajoute un produit au panier utilisateur.
     * @param {Object} payload - Objet contenant l'identifiant d'un produit.
     */
    addToCart (payload) {
      let existCheck = false
      this.dataStore.panier.forEach(item => {
        if (item[0] === payload.id) {
          item[1] += payload.qte
          existCheck = true
        }
      })
      if (!existCheck) {
        this.dataStore.panier.push([payload.id, payload.qte, payload.libelle, payload.prix, payload.prixCalcule, payload.uniteComm])
      }
    },
    /**
     * Summary : Ajoute un filtre aux produits.
     * @param {Object} payload - Objet contenant les caractéristiques du filtre de produits.
     */
    async setNewFilter (payload) {
      if (payload.length === 0) return
      let url = this.baseURL + '_products'
      const bodyFormData = new FormData()
      bodyFormData.append(Object.getOwnPropertyNames(payload[0])[0], payload[0][Object.getOwnPropertyNames(payload[0])[0]])

      if (Object.keys(payload[0]).length > 1) {
        bodyFormData.append(Object.getOwnPropertyNames(payload[0])[1], payload[0][Object.getOwnPropertyNames(payload[0])[1]])
      }
      if (payload.length > 1) {
        bodyFormData.append(Object.getOwnPropertyNames(payload[1])[0], payload[1][Object.getOwnPropertyNames(payload[1])[0]])
        if (Object.keys(payload[1]).length > 1) {
          bodyFormData.append(Object.getOwnPropertyNames(payload[1])[1], payload[1][Object.getOwnPropertyNames(payload[1])[1]])
        }
      }
      url = url.normalize('NFD').replace(/ /g, '%20')
      const response = await axios.post(url, bodyFormData)
      if (!Array.isArray(response.data)) {
        this.produits = null
        return
      }
      for (const item in response.data) {
        const reponse = await axios.get(this.baseURL + response.data[item].ID_Produit + '/_echellons')
        response.data[item].echellons = reponse.data
      }
      this.produits = response.data
    },
    /**
     * Summary : Réinitialise les filtres.
     */
    async resetFilters () {
      const url = this.baseURL + '_products'
      const response = await axios.post(url)
      for (const item in response.data) {
        const reponse = await axios.get(this.baseURL + response.data[item].ID_Produit + '/_echellons')
        response.data[item].echellons = reponse.data
      }
      this.produits = response.data
    }
  },
  async mounted () {
    const url = this.baseURL + '_products'
    const response = await axios.post(url)
    for (const item in response.data) {
      const reponse = await axios.get(this.baseURL + response.data[item].ID_Produit + '/_echellons')
      response.data[item].echellons = reponse.data
    }
    this.produits = response.data
  }
}
</script>

<style scoped>
  .products {
    margin-bottom: 10vh;
  }
  #products-list {
    width: 100vw;
    display: flex;
    justify-content: space-evenly;
    flex-direction: row;
    flex-wrap: wrap;
  }
  img:nth-of-type(1) {
    width: 100vw;
    height: 30vh;
  }
</style>
