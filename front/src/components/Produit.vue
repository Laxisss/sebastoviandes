<template>
  <div class="card-product">
    <div class="row">
      <div id="image">
        <img alt="Photo du produit" :src="lienPhoto"/>
      </div>
      <div id="info">
        <span> {{ nom }} </span>
        <span> {{ realPrice }} / {{ unite }} </span>
        <span v-if="uniteComm === 'pce'"> 1 pce &#8776; {{ grammage }}g</span>
      </div>
    </div>
    <div class="fast-fill">
      <span v-for="item in parPers.length" :key="item">
        <button v-if="parPers[item - 1]"  @click="pers(parPers[item - 1])" >{{ parPers[item - 1].Libelle }} / {{ parPers[item - 1].Valeur }}<span v-if="uniteComm === 'pce'">&nbsp;</span>{{ uniteComm }}</button>
      </span>
    </div>
    <div class="last-row">
      <button @click="addToCart"> Ajouter au panier </button>
      <span v-if="parseFloat(prixCalcule) > 0"> {{ parseFloat(prixCalcule) }} € </span>
      <div id="buttons" ref="buttons">
        <button @click="decrQte" >-</button>
        <span>
          <span v-if="quantite < 1000 || uniteComm === 'pce'">
            {{ quantite }}
          </span>
          <span v-else>
            {{ quantite/1000 }}
          </span>
          <span v-if="quantite < 1000 || uniteComm === 'pce'">
            {{ uniteComm }}
          </span>
          <span v-else>
            {{ unite }}
          </span>
        </span>
        <button @click="incrQte" >+</button>
      </div>
    </div>
  </div>
</template>

<script>
import { store } from '../store'
export default {
  name: 'Produit',
  data () {
    return {
      quantite: 0,
      prixCalcule: 0.0,
      baseURL: store.baseURL
    }
  },
  props: {
    id: Number,
    prix: String,
    nom: String,
    unite: String,
    uniteComm: String,
    grammage: Number,
    parPers: Array,
    lienPhoto: String
  },
  computed: {
    realPrice () {
      return this.prix.split('.')[1].length > 2 ? this.prix : this.prix.split('.')[0] + '.' + this.prix.split('.')[1][0] + '0€'
    }
  },
  watch: {
    quantite: function (newVal, oldVal) {
      this.prixCalcule = this.uniteComm === 'g' ? Math.round((parseFloat(this.prix) * (parseFloat(this.quantite) / 1000)) * 100) / 100 : Math.round((parseFloat(this.prix) * (parseFloat(this.quantite * this.grammage) / 1000)) * 100) / 100
      if (this.prixCalcule < 1 && this.uniteComm !== 'pce') {
        if (newVal > oldVal) {
          this.incrQte()
        } else {
          this.quantite = 0
        }
      }
    }
  },
  methods: {
    /**
     * Summary : Incrémente la quantité du produit.
     */
    incrQte () {
      this.quantite = this.uniteComm === 'g' ? this.quantite + 50 : this.quantite + 1
    },
    /**
     * Summary : Décrémente la quantité du produit.
     */
    decrQte () {
      if (this.uniteComm === 'g') {
        if (this.quantite < 50) return
        this.quantite = this.quantite > 0 ? this.quantite - 50 : this.quantite
      } else {
        this.quantite = this.quantite > 0 ? this.quantite - 1 : this.quantite
      }
    },
    /**
     * Summary : Définit la quantité du produit par rapport au bouton d'échellon cliqué.
     */
    pers (arr) {
      this.quantite = Number(arr.Valeur)
    },
    /**
     * Summary : Ajoute ce produit au panier.
     * Description : Vérifie que la quantité est supérieure à Zéro et émet un évènement d'ajout au panier.
     */
    addToCart () {
      if (this.quantite === 0) {
        this.$refs.buttons.classList.add('refusal')
        setTimeout(this.resetElem.bind(null, this.$refs.buttons), 100)
        return
      }
      this.$emit('addToCart', {
        id: this.id,
        qte: this.quantite,
        libelle: this.nom,
        prix: this.prix,
        prixCalcule: this.prixCalcule,
        uniteComm: this.uniteComm
      })
    },
    /**
     * Summary : Réinitialise l'élément.
     * Description : Appelé après addToCart lorsque la quantité est égale à 0.
     */
    resetElem (elem) {
      elem.classList.remove('refusal')
    }
  }
}
</script>

<style scoped>
  .last-row {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    flex-wrap: wrap;
  }
  .fast-fill {
    margin-bottom: 10px;
    display: flex;
    flex-direction: row;
    justify-content: space-around;
    flex-wrap: wrap;
  }
  .row {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    margin-bottom: 10px;
  }
  .card-product {
    width: 22%;
    padding: 8px;
    border-radius: 8px;
    margin-top: 10px;
    box-shadow: 5px 5px 5px 5px gainsboro;
  }
  #image {
    width: 100px;
    height: 100px;
    background-color: red;
    overflow: hidden;
  }
  #image img {
    width: 100px;
    height: 100px;
  }
  #info {
    max-height: 100px;
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
  }
  button {
    background-color: whitesmoke;
    border: none;
    cursor: pointer;
    padding: 5px;
  }
  button:hover {
    background-color: gainsboro;
  }
  button:active {
    background-color: lightgray;
  }
  .refusal {
    animation: refusal .1s linear infinite;
  }
  @keyframes refusal {
    25% {
      transform: translateX(-2px);
    }
    50% {
      background-color: red;
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
