<template>
  <div>
    <div id="day">
      <button @click="date > 0 ? date-- : date">&larr;</button>
      <span>{{ dates[date][0] }}</span>
      <button @click="date < 4 ? date++ : date">&rarr;</button>
    </div>
    <hr/>
    <div id="commandes" v-if="commandes && commandes.length > 0">
      <Commande @validate="getCommandes" v-for="item in commandes.length" :key="item" :produits="commandes[item - 1]"/>
    </div>
    <div v-else>
      <h1>Aucune commande pour le {{ dates[date][0] }}</h1>
    </div>
  </div>
</template>

<script>
import { store } from '../store'
import axios from 'axios'
import Commande from '../components/Commande.vue'
export default {
  name: 'Commandes',
  components: {
    Commande
  },
  data () {
    return {
      dataStore: store,
      baseURL: store.baseURL,
      commandes: [],
      date: 0
    }
  },
  watch: {
    date () {
      this.getCommandes()
    }
  },
  computed: {
    /**
     * Summary : Récupère la date du jour.
     * @returns {Array} Liste contenant la date du jour au format Français et Américain
     */
    currDate () {
      const d = new Date()
      const dateFr = d.getDate() + '/' + (Number(d.getMonth() + 1) < 10 ? '0' + Number(d.getMonth() + 1) : Number(d.getMonth() + 1)) + '/' + d.getFullYear()
      const dateEn = d.getFullYear() + '-' + (Number(d.getMonth() + 1) < 10 ? '0' + Number(d.getMonth() + 1) : Number(d.getMonth() + 1)) + '-' + d.getDate()
      return [dateFr, dateEn]
    },
    /**
     * Summary : Crée une liste contenant la date des 5 jours suivant aujourd'hui.
     * @returns {Array} Liste contenant 5 listes correspondant aux dates des 5 jours suivant aujourd'hui au format ['JJ-MM-YYYY','YYYY-MM-JJ']
     */
    dates () {
      const today = new Date(this.currDate[1])
      const datesArr = []
      for (let i = today.getDate(); i < today.getDate() + 5; i++) {
        const reference = new Date(today.getFullYear(), today.getMonth(), i)
        const arr = [reference.getDate() + '/' + (Number(reference.getMonth() + 1) < 10 ? '0' + Number(reference.getMonth() + 1) : Number(reference.getMonth() + 1)) + '/' + reference.getFullYear(), reference.getFullYear() + '-' + (Number(reference.getMonth() + 1) < 10 ? '0' + Number(reference.getMonth() + 1) : Number(reference.getMonth() + 1)) + '-' + reference.getDate()]
        datesArr.push(arr)
      }
      return datesArr
    }
  },
  methods: {
    /**
     * Summary : Récupère la liste des commandes.
     */
    async getCommandes () {
      const url = this.baseURL + '_getCommandes'
      const bodyFormData = new FormData()
      bodyFormData.append('date', this.dates[this.date][1])
      const response = await axios.post(url, bodyFormData)
      if (response.data.length === 0) {
        this.commandes = []
        return
      }
      const commandesArray = []
      for (let i = 0; i < response.data.at(-1).ID_Commandes; i++) {
        commandesArray[i] = []
        for (let j = 0; j < response.data.length; j++) {
          if (Number(response.data[j].ID_Commandes) === i + 1) {
            commandesArray[i].push(response.data[j])
          }
        }
      }
      const result = commandesArray.filter(e => e.length)
      this.commandes = result
    }
  },
  mounted () {
    this.getCommandes()
  }
}
</script>

<style scoped>
  #commandes {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    flex-wrap: wrap;
  }
  #day {
    width: 50%;
    display: flex;
    justify-content: space-evenly;
    margin: auto;
    height: 30px;
    font-size: 30px;
  }
  #day button {
    font-size: inherit;
    display: flex;
    justify-content: center;
    align-items: center;
    border: 1px solid gainsboro;
    border-radius: 8px;
  }
  button:hover {
    background-color: lightgray;
    cursor: pointer;
  }
  button:active {
    background-color: gray;
  }
  hr {
    margin: 0;
  }
</style>
