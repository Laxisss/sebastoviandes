<template>
  <div ref="elem" id="elem">
    <div id="row1">
      <div id="col1">
        <label for="typeProduit">Type de produit :</label>
        <article v-for="item in typeProduitsArray.length" :key="item">
          <input type="radio" :value="typeProduitsArray[item - 1].ID_TypeProduit" name="typeProduit"/>&nbsp;<span>{{ typeProduitsArray[item - 1].Libelle }}</span><br/>
        </article>
      </div>
      <div id="col2">
        <label for="price">Prix :</label>
        <article>
          <input type="radio" data-min="1" data-max="5" name="price"/>&nbsp;<span>de 1€ à 5€</span><br/>
        </article>
        <article>
          <input type="radio" data-min="5" data-max="10" name="price"/>&nbsp;<span>de 5€ à 10€</span><br/>
        </article>
        <article>
          <input type="radio" data-min="10" data-max="15" name="price"/>&nbsp;<span>de 10€ à 15€</span><br/>
        </article>
        <article>
          <input type="radio" data-min="15" data-max="20" name="price"/>&nbsp;<span>de 15€ à 20€</span>
        </article>
        <article>
          <input type="radio" data-min="20" data-max="25" name="price"/>&nbsp;<span>de 20€ à 25€</span>
        </article>
        <article>
          <input type="radio" data-min="25" data-max="30" name="price"/>&nbsp;<span>de 25€ à 30€</span>
        </article>
      </div>
    </div>
    <div id="row2">
      <button class="link" @click="setNewFilter">Appliquer les filtres</button>
      <button class="link" @click="reinit">Réinitialiser les filtres</button>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import { store } from '../store.js'
export default {
  name: 'Filtre',
  data () {
    return {
      typeProduitsArray: [],
      baseURL: store.baseURL
    }
  },
  methods: {
    /**
     * Summary : Permet de définir un nouveau filtre de recherche de produits.
     */
    setNewFilter () {
      const finalArray = []
      const checkedBoxes = Array.from(this.$refs.elem.querySelectorAll('input[type="radio"]'))
      for (let i = 0; i < checkedBoxes.length; i++) {
        if (checkedBoxes[i].checked) {
          if (checkedBoxes[i].name === 'typeProduit') {
            finalArray.push({ typeProduit: checkedBoxes[i].value })
          } else if (checkedBoxes[i].name === 'price') {
            finalArray.push({ prixMin: checkedBoxes[i].getAttribute('data-min'), prixMax: checkedBoxes[i].getAttribute('data-max') })
          }
        }
      }
      this.$emit('setNewFilter', finalArray)
    },
    /**
     * Summary : Réinitialise les filtres de recherches.
     */
    reinit () {
      const checkedBoxes = Array.from(this.$refs.elem.querySelectorAll('input[type="radio"]'))
      for (let i = 0; i < checkedBoxes.length; i++) {
        checkedBoxes[i].checked = false
      }
      this.$emit('resetFilters')
    },
    /**
     * Summary : Récupère les types de produits.
     */
    async getTypesProduits () {
      const url = this.baseURL + '_types'
      const response = await axios.get(url)
      this.typeProduitsArray = response.data
    }
  },
  created () {
    this.getTypesProduits()
  }
}
</script>

<style scoped>
  #elem {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: flex-end;
  }
  #row1 {
    display: flex;
    justify-content: flex-end;
    align-items: center;
  }
  #col1, #col2 {
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: flex-start;
  }
  #row2 {
    display: flex;
    justify-content: space-evenly;
  }
  #col1 + #col2 {
    margin-left: 10px;
  }
  input[type=radio] {
    filter: invert(0%) hue-rotate(18deg) brightness(1.7);;
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
  .link:hover {
    background-color: #d63b3b;
  }
</style>
