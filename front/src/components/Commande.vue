<template>
  <div id="commande">
    <span>Commande n°{{ produits[0].ID_Commandes }}</span><br/>
    <span>Client : {{ produits[0].Client }}</span><br/>
    <span class="contact-data" @click="showTel = !showTel">
      <span v-if="showTel">
        Tel : {{ produits[0].NumTel }}
      </span>
      <span v-else>
        Email : {{ produits[0].Email }}
      </span>
    </span><br/>
    <div class="produit" v-for="item in produits.length" :key="item">
      <span>{{ produits[item - 1].Libelle }}:&nbsp;</span>
      <span>{{ produits[item - 1].Quantite }}&nbsp;</span>
      <span>{{ produits[item - 1].prixCalcule }}€</span>
    </div>
    <span>Total : {{ totPrix }}€</span>
    <button @click="validate">Valider</button>
  </div>
</template>

<script>
import axios from 'axios'
import { store } from '../store'
export default {
  name: 'Commande',
  props: {
    produits: Array
  },
  data () {
    return {
      baseURL: store.baseURL,
      showTel: true
    }
  },
  computed: {
    /**
     * Summary : Calcule le prix total de la commande.
     * @returns {float} Prix de la commande arrondi à 10^-2
     */
    totPrix () {
      let result = 0
      for (const item in this.produits) {
        result += Number(this.produits[item].prixCalcule)
      }
      return Math.round(result * 100) / 100
    }
  },
  methods: {
    /**
     * Summary : Valide la commande comme étant récupérée.
     * Description : Permet de mettre a jour la commande en bdd afin de lui ajouter la valeur true au champ récupérée.
     */
    async validate () {
      const id = this.produits[0].ID_Commandes
      const url = this.baseURL + id + '/_validateCommande'
      const response = await axios.get(url)
      if (response.data === true) {
        this.$emit('validate')
      }
    }
  }
}
</script>

<style scoped>
  .contact-data {
    cursor: pointer;
  }
  #commande {
    width: fit-content;
    min-width: 250px;
    padding: 8px;
    box-shadow: 5px 5px 5px 5px gainsboro;
    border-radius: 8px;
    margin-top: 10px;
    text-align: left;
  }
  .produit {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    width: fit-content;
  }
  .produit span:nth-of-type(1) {
    width: 50%;
    overflow: visible;
    white-space: nowrap;
  }
  span:not(.produit span) {
    color: red;
  }
  .produit span {
    font-weight: 600;
    min-width: fit-content;
  }
  button {
    float: right;
    border-radius: 8px;
    border: none;
    background-color: whitesmoke;
    box-shadow: 2px 2px 2px 2px gainsboro;
    padding: 5px;
  }
  button:hover{
    transform: translateY(3px);
    box-shadow: 2px 0 2px 2px gainsboro;
    background-color: lightgray;
    cursor: pointer;
  }
</style>
