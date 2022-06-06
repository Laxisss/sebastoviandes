<template>
  <div id="produits-manager">
    <label for="search">Recherche :</label><br/>
    <input type="text" v-model="searchFilter" name="searchbar"/><br/><br/>
    <button @click="create = !create; echec = ''">Créer un produit</button>
    <div v-if="create">
      <p v-if="echec !== ''">Echec lors de {{ echec }}</p>
      <p v-if="echec !== ''">Veuillez vérifier vos informations</p>
      <form onsubmit="return false;" ref="form" enctype="multipart/form-data">
        <div>
          <label for="name">Nom</label><br/>
          <input v-model="lib" type="text" name="name" placeholder="Entrez le nom du produit" required/><br/><br/>
          <label for="price">Prix</label><br/>
          <span style="white-space: nowrap;"><input v-model="prix" type="text" name="price" placeholder="Entrez le prix du produit" required/>€</span><br/><br/>
          <label for="unit">Unité</label><br/>
          <select v-model="unite" name="unit" id="unit">
            <option selected="true" disabled value="0">Sélectionnez une unité pour le prix</option>
            <option value="kg">kg</option>
            <option value="pce">pièce</option>
          </select><br/><br/>
          <label for="photo">Image</label><br/>
          <input ref="img" accept="image/png, image/jpeg" type="file" name="photo" placeholder="Entrez la photo du produit"/><br/><br/>
        </div>
        <div>
          <div id="echellons">
            <span>
              <label for="ech1">Echellon 1</label><br/>
              <input type="text" v-model="echellons[0].nom" placeholder="Nom"/>
              <input type="text" v-model="echellons[0].qte" placeholder="Quantite"/>
            </span>
            <span>
              <label for="ech1">Echellon 2</label><br/>
              <input type="text" v-model="echellons[1].nom" placeholder="Nom"/>
              <input type="text" v-model="echellons[1].qte" placeholder="Quantite"/>
            </span>
            <span>
              <label for="ech1">Echellon 3</label><br/>
              <input type="text" v-model="echellons[2].nom" placeholder="Nom"/>
              <input type="text" v-model="echellons[2].qte" placeholder="Quantite"/>
            </span>
          </div>
          <label for="type">Type de produit</label><br/>
          <select v-model="type" value="0" ref="type">
            <option value="0" selected="true" disabled>Selectionnez un type de produit</option>
            <option v-for="type in typeProduitsArray" :key="type.ID_TypeProduit" :value="type.ID_TypeProduit">{{ type.Libelle }}</option>
            <option value="-1">Nouveau type de produit</option>
          </select>
          <input v-if="type === '-1'" type="text" placeholder="Nom du type de produit" v-model="newType"/>
          <br/><br/>
          <label for="uniteAchat">Unité d'achat</label><br/>
          <select v-model="uniteComm" name="unitAchat" id="unitAchat">
            <option selected="true" disabled value="0">Sélectionnez une unité d'achat</option>
            <option value="g">kg</option>
            <option value="pce">pièce</option>
          </select>
          <div v-if="uniteComm === 'pce'">
            <label for="grammage">Grammage (Poids d'une pièce)</label><br/>
            <input type="text" v-model="grammage" name="grammage" placeholder="Entrez le poids d'une pièce en grammes"/><br/><br/>
          </div>
        </div>
      </form>
      <input type="submit" @click="createProduit" value="Créer le produit"/>
    </div>
    <table border="1">
      <thead>
        <th>Nom</th>
        <th>Prix</th>
        <th>Unite</th>
        <th>Photo</th>
        <th>Type de viande</th>
        <th>Unite d'achat</th>
        <th>Grammage</th>
        <th>Changements</th>
      </thead>
      <tbody>
        <ProduitManager @reset="getProduits" :ID_TypeProduit="Number(produits[item - 1].ID_TypeProduit)" :ID_Produit="Number(produits[item - 1].ID_Produit)" :Grammage="Number(produits[item - 1].Grammage)" :UniteComm="produits[item - 1].UniteComm" :TypeProduit="produits[item - 1].TypeProduit" :Unite="produits[item - 1].Unite" :Libelle="produits[item - 1].Libelle" :Prix="Number(produits[item - 1].Prix)" v-for="item in produits.length" :key="item"/>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios'
import { store } from '../store'
import ProduitManager from './ProduitManager.vue'
export default {
  name: 'ProduitsManager',
  components: {
    ProduitManager
  },
  data () {
    return {
      produits: [],
      baseURL: store.baseURL,
      searchFilter: '',
      create: false,
      echec: '',
      typeProduitsArray: [],
      uniteComm: '0',
      lib: '',
      prix: 0,
      unite: '0',
      type: 0,
      grammage: '',
      newType: '',
      echellons: [
        {
          nom: '',
          qte: ''
        },
        {
          nom: '',
          qte: ''
        },
        {
          nom: '',
          qte: ''
        }
      ]
    }
  },
  methods: {
    /**
     * Summary: Récupère l'ensemble des produits.
     */
    async getProduits () {
      console.clear()
      console.log(new Date().toLocaleString('fr-FR'))
      console.log('Récupération des produits...')
      const url = this.baseURL + '_products'
      const response = await axios.post(url)
      if (!Array.isArray(response.data)) {
        console.error('Une erreur est survenue')
        return
      }
      for (const item in response.data) {
        const reponse = await axios.get(this.baseURL + response.data[item].ID_Produit + '/_echellons')
        response.data[item].echellons = reponse.data
      }
      this.produits = []
      this.produits = response.data
      console.log('Produits récupérés avec succès')
    },
    /**
     * Summary: Récupère les types de produits.
     */
    async getTypesProduits () {
      const url = this.baseURL + '_types'
      const response = await axios.get(url)
      this.typeProduitsArray = response.data
    },
    /**
     * Summary: Insère un nouveau produit en base de données
     */
    async createProduit () {
      console.log(this.$refs.form)
      const bodyFormData = new FormData()
      bodyFormData.append('lib', this.lib)
      bodyFormData.append('prix', Number(this.prix.normalize('NFD').replace(/,/g, '.').replace(/[^0-9,.]/g, '')))
      bodyFormData.append('unit', this.unite)
      bodyFormData.append('type', this.type !== '-1' ? this.type : this.newType)
      bodyFormData.append('unitComm', this.uniteComm)
      bodyFormData.append('grammage', Number(this.grammage))
      bodyFormData.append('image', this.$refs.img.files[0])
      this.echellons.forEach(item => {
        bodyFormData.append('echellons[]', [item.nom, item.qte])
      })
      const url = this.baseURL + '_addProducts'
      const response = await axios.post(url, bodyFormData)
      if (response.data === true) {
        alert('Produit inséré avec succès')
        this.getProduits()
        this.uniteComm = '0'
        this.lib = ''
        this.prix = 0
        this.unite = '0'
        this.type = 0
        this.grammage = ''
        this.echellons = [
          {
            nom: '',
            qte: ''
          },
          {
            nom: '',
            qte: ''
          },
          {
            nom: '',
            qte: ''
          }
        ]
        if (this.newType) {
          this.getTypesProduits()
          this.newType = ''
        }
      } else {
        alert('Echec lors de la création du produit')
        console.error('Echec lors de la création du produit' + response.data)
      }
    }
  },
  mounted () {
    this.getProduits()
    this.getTypesProduits()
  }
}
</script>

<style scoped>
  form div div {
    width: 100%;
  }
  form div {
    width: max-content;
  }
  table {
    width: 100%;
    border-collapse: collapse;
  }
  th {
    font-size: 13px;
  }
  form {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
    width: 100%;
  }
  form input[type=text], form input[type=password],input[type=file] {
    padding: 10px;
    border: 1px solid gainsboro;
    border-radius: 16px;
    width: calc(100% - 20px);
  }
  form select {
    width: 100%;
    border: 1px solid gainsboro;
    border-radius: 16px;
    padding: 10px;
  }
  button:not(td button), input[type=submit] {
    padding: 10px;
    margin-bottom: 10px;
    background-color: red;
    border: 1px solid gainsboro;
    border-radius: 16px;
    color: white;
  }
  button:not(td button):hover, input[type=submit]:hover {
    background-color: rgb(197, 8, 8);
    cursor: pointer;
  }
  button:not(td button):active, input[type=submit]:active {
    background-color: rgb(158, 6, 6);
    cursor: pointer;
  }
  input:not(form input):not(td input) {
    width: 250px;
    padding: 10px;
    border: 1px solid gainsboro;
    border-radius: 16px;
  }
  @media screen and (max-width: 750px) {
    th {
      font-size: 8px;
    }
  }
  #echellons {
    display: flex;
    justify-content: center;
  }
  #echellons span input{
    max-width: 50px;
  }
</style>
