<template>
  <tr>
    <td><input type="text" class="lib" v-model="libelle"></td>
    <td><input type="text" v-model="prix" class="price"/>€</td>
    <td>
      <select class="unit" :value="unite">
        <option value="kg">kg</option>
        <option value="pce">pce</option>
      </select>
    </td>
    <td>
      <label class="label" for="picture">Importer</label>
      <input id="picture" type="file" accept="image/png, image/jpeg" ref="img"/>
    </td>
    <td v-if="typeProduitsArray">
      <select v-model="id_TypeProduit">
        <option v-for="type in typeProduitsArray" :key="type.ID_TypeProduit" :value="type.ID_TypeProduit">{{ type.Libelle }}</option>
      </select>
    </td>
    <td>
      <select class="unit" v-model="uniteComm">
        <option value="g">g</option>
        <option value="pce">pce</option>
      </select>
    </td>
    <td>
      <span v-if="grammage > 0 || gramsFocus"><input @mouseleave="gramsFocus = false" @focus="gramsFocus = true" type="text" @blur="gramsFocus = false" class="grams" v-model="grammage"/>g</span>
      <span @click="gramsFocus = true" v-else>Pas de pièce</span>
    </td>
    <td><button @click="validate">Valider</button></td>
  </tr>
</template>

<script>
import axios from 'axios'
import { store } from '../store'
export default {
  name: 'ProduitManager',
  data () {
    return {
      typeProduitsArray: [],
      baseURL: store.baseURL,
      prix: this.Prix,
      libelle: this.Libelle,
      unite: this.Unite,
      typeProduit: this.TypeProduit,
      id_TypeProduit: this.ID_TypeProduit,
      uniteComm: this.UniteComm,
      grammage: this.Grammage,
      gramsFocus: false
    }
  },
  props: {
    ID_Produit: Number,
    Libelle: String,
    Prix: Number,
    Unite: String,
    TypeProduit: String,
    ID_TypeProduit: Number,
    UniteComm: String,
    Grammage: Number
  },
  methods: {
    /**
     * Summary: Récupère les types de produits.
     */
    async getTypesProduits () {
      const url = this.baseURL + '_types'
      const response = await axios.get(url)
      this.typeProduitsArray = response.data
    },
    /**
     * Summary: Valide les modifications apportées au produit.
     */
    async validate () {
      const bodyFormData = new FormData()
      bodyFormData.append('id', this.ID_Produit)
      bodyFormData.append('lib', this.libelle)
      bodyFormData.append('prix', this.prix)
      bodyFormData.append('unit', this.unite)
      bodyFormData.append('type', this.id_TypeProduit)
      bodyFormData.append('unitComm', this.uniteComm)
      if (this.uniteComm === 'pce') {
        bodyFormData.append('grams', this.grammage)
      }
      if (this.$refs.img.files[0]) {
        bodyFormData.append('image', this.$refs.img.files[0])
      }
      const url = this.baseURL + '_updateProducts'
      const response = await axios.post(url, bodyFormData)
      if (response.data === true) {
        alert('Produit modifié avec succès')
        this.$emit('reset')
      } else {
        alert('Echec lors de la modification du produit')
        console.log(response.data)
      }
    }
  },
  mounted () {
    this.getTypesProduits()
  }
}
</script>

<style scoped>
  input {
    width: calc(100% - 8px);
    height: 100%;
    -webkit-transition: width .35s ease-in-out;
    transition: width .35s ease-in-out;
  }
  select.unit {
    min-width: 10px;
  }
  select {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    text-indent: 0.01px;
    text-overflow: '';
    width: 100%;
  }
  @media screen and (max-width: 1050px) {
    input:focus {
      width: 150px;
    }
    input.price:focus {
      width: 150px;
    }
  }
  input.price {
    width: calc(100% - 20px);
  }
  input.grams {
    width: calc(100% - 15px);
  }
  td {
    white-space: nowrap;
  }
  input[type=file] {
    width: 0.1px;
    height: 0.1px;
    overflow: hidden;
    white-space: nowrap;
    position: absolute;
  }
  .label {
    border: 2px solid gainsboro;
    background-color: rgb(245, 245, 245);
    font-size: 13.333333333px;
    width: 100%;
    height: 100%;
    padding: 1px 6px;
  }
  .label:hover {
    cursor: pointer;
    background-color: rgb(202, 200, 200);
  }
  button:hover {
    cursor: pointer;
  }
  span {
    font-size: 13.333333333px;
  }
  td button {
    width: 100%;
  }
</style>
