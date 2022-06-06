<template>
  <div class="products">
    <img src="../images/peppa.png"/>
    <Bandeau :retourPath="'/products'"/>
    <div id="products-list" v-if="dataStore.panier.length > 0 && !validate && !echec">
      <div class="product" v-for="item in dataStore.panier.length" :key="item">
        <span>{{ dataStore.panier[item - 1][2] }}</span>
        <span>{{ dataStore.panier[item - 1][1] }} {{ dataStore.panier[item - 1][5] }}</span>
        <span>{{ dataStore.panier[item - 1][4] }} € <button class="suppr" @click="removeItem(item)">X</button></span>
      </div>
      <div id="tot">
        <span>Total:</span>
        <span>Approx* {{ totPrix }} €</span>
      </div>
      <span class="asterix">* Les prix peuvent légèrement varier car les mesures ne sont pas toujours précises</span>
      <div id="to-float-right">
        <p>Date de récupération : </p>
        <input :min="currDate" type="date" ref="date" v-model="date"/><br/>
        <button @click="checkSession" id="validate">Valider le panier</button>
      </div>
    </div>
    <div v-else-if="validate">
      <h1>Votre panier a été validé</h1>
    </div>
    <div v-else-if="echec">
      <h1>L'envoi de votre panier a échoué</h1>
      <button class="suppr" @click="echec = false">Réessayer</button>
    </div>
    <div v-else>
      <h1>Votre panier est vide</h1>
    </div>
  </div>
</template>

<script>
import Bandeau from '../components/Bandeau.vue'
import { store } from '../store'
import axios from 'axios'

export default {
  name: 'Panier',
  components: {
    Bandeau
  },
  data () {
    return {
      dataStore: store,
      baseURL: store.baseURL,
      validate: false,
      echec: false
    }
  },
  computed: {
    date: {
      set (val) {
        this.dataStore.dateRecup = val
      },
      get () {
        return this.dataStore.dateRecup
      }
    },
    totPrix () {
      let result = 0
      for (const item in this.dataStore.panier) {
        result += this.dataStore.panier[item][4]
      }
      return Math.round(result * 100) / 100
    },
    currDate () {
      const d = new Date()
      console.log(d.getFullYear() + '-' + (Number(d.getMonth() + 1) < 10 ? '0' + Number(d.getMonth() + 1) : Number(d.getMonth() + 1)) + '-' + d.getDate())
      return d.getFullYear() + '-' + (Number(d.getMonth() + 1) < 10 ? '0' + Number(d.getMonth() + 1) : Number(d.getMonth() + 1)) + '-' + d.getDate()
    }
  },
  methods: {
    /**
     * Summary : Valide le panier.
     * Description : Vérifie que l'utilisateur est connecté, que la date est bonne etc...
     */
    async checkSession () {
      if (this.date === '' || Date.parse(this.date) < Date.parse(this.currDate)) {
        this.$refs.date.classList.add('refusal')
        setTimeout(this.resetElem.bind(null, this.$refs.date), 100)
        return
      }
      if (sessionStorage.getItem('id') === null) {
        this.$router.push('/login')
      } else {
        const bodyFormData = new FormData()
        this.dataStore.panier.forEach(item => bodyFormData.append('panier[]', item))
        bodyFormData.append('dateRecup', this.date)
        bodyFormData.append('userID', this.compte.id)
        console.log(bodyFormData.getAll('panier[]'))
        const response = await axios.post(this.baseURL + '_addCommande', bodyFormData)
        if (response.data !== true) {
          console.log(response.data)
          this.echec = true
          this.validate = false
        } else {
          this.echec = false
          this.validate = true
          this.dataStore.panier = []
          setTimeout(this.goBackToMenu, 3000)
        }
      }
    },
    /**
     * Summary : Réinitialise l'élément.
     * @param {Element} elem - Element à réinitialiser.
     */
    resetElem (elem) {
      elem.classList.remove('refusal')
    },
    /**
     * Summary : Redirige vers le menu.
     */
    goBackToMenu () {
      this.$router.push('/')
    },
    /**
     * Summary : Supprime un produit du panier.
     * @param {Number} item - Index du produit dans le panier.
     */
    removeItem (item) {
      this.dataStore.panier.forEach(elem => {
        if (this.dataStore.panier.indexOf(elem) === item - 1) {
          this.dataStore.panier.splice(this.dataStore.panier.indexOf(elem), 1)
        }
      })
    }
  }
}
</script>

<style scoped>
  .suppr {
    border: none;
    padding: 3px 9px;
    text-decoration: none;
    color: white;
    background-color: #f04c4c;
    border-radius: 8px;
    cursor: pointer;
  }
  .suppr:hover {
    background-color: #d63b3b;
  }
  .suppr:active {
    background-color: #c21c1c;
  }
  #to-float-right {
    width: 90vw;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-end;
  }
  #validate {
    float: right;
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
    height: 25px;
    font-size: 16px;
  }
  h1 {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  .asterix {
    font-size: 10px;
  }
  img:nth-of-type(1) {
    width: 100vw;
    height: 30vh;
  }
  span:nth-of-type(1) {
    width: 10px;
    overflow: visible;
    white-space: nowrap;
  }
  #products-list {
    width: 100vw;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
  .product {
    width: 90vw;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    background-color: lightgray;
    padding: 10px;
  }
  .product:nth-child(even) {
    background: gainsboro;
  }
  #tot {
    width: 90vw;
    padding: 10px;
    display: flex;
    justify-content: space-between;
    background-color: whitesmoke;
  }
  input[type=date] {
    padding: 5px;
    border: 1px solid gainsboro;
    border-radius: 8px;
  }
  .refusal {
    animation: refusal .1s linear infinite;
  }
  @keyframes refusal {
    25% {
      transform: translateX(-2px);
    }
    50% {
      color: red;
    }
    75% {
      transform: translateX(2px);
    }
    100% {
      background-color: initial;
      transform: translateX(0px);
    }
  }
</style>
