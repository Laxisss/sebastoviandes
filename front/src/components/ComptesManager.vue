<template>
  <div id="compteManager">
    <label for="search">Recherche :</label><br/>
    <input type="text" v-model="searchFilter" name="searchbar"/><br/><br/>
    <button @click="create = !create; echec = ''">Créer un compte</button>
    <div v-if="create">
      <p v-if="echec !== ''">Echec lors de {{ echec }}</p>
      <p v-if="echec !== ''">Veuillez vérifier vos informations</p>
      <form onsubmit="return false;" ref="signUp">
        <div>
          <label for="name">Nom</label><br/>
          <input type="text" name="name" placeholder="Entrez votre nom" required/><br/><br/>
          <label for="firstname">Prenom</label><br/>
          <input type="text" name="firstname" placeholder="Entrez votre prénom" required/><br/><br/>
          <label for="email">Adresse E-mail</label><br/>
          <input type="text" name="email" placeholder="Entrez votre adresse e-mail"/><br/><br/>
        </div>
        <div>
          <label for="phone">Numéro de téléphone</label><br/>
          <input type="text" name="phone" placeholder="Entrez votre numéro de téléphone"/><br/><br/>
          <label for="password">Mot de passe</label><br/>
          <input type="password" name="password" placeholder="Entrez votre mot de passe" required/><br/><br/>
          <label for="password2">Confirmer Mot de passe</label><br/>
          <input type="password" name="password2" placeholder="Réécrivez votre mot de passe" required/><br/><br/>
          <label for="admin">Rôle d'administrateur</label><br/>
          <input type="checkbox" name="admin"/>
        </div>
      </form>
      <input @click="signUp" type="submit" value="S'inscrire"/>
    </div>
    <table border="1">
      <thead>
        <tr>
          <th>Nom</th>
          <th>Prenom</th>
          <th>Adresse E-mail</th>
          <th>Numéro de Téléphone</th>
          <th>Mot de passe</th>
          <th>Modifier le mot de passe</th>
          <th>Supprimer le compte</th>
        </tr>
      </thead>
      <tbody v-if="comptes">
        <CompteManager @refresh="refresh" :NumTel="comptes[item - 1].NumTel" :ID_Compte="comptes[item - 1].ID_Utilisateur" :Email="comptes[item - 1].Email" :Nom="comptes[item - 1].Nom" :Prenom="comptes[item - 1].Prenom" v-for="item in comptes.length" :key="item"/>
      </tbody>
    </table>
  </div>
</template>

<script>
import axios from 'axios'
import { store } from '../store'
import CompteManager from './CompteManager.vue'
export default {
  name: 'ComptesManager',
  components: {
    CompteManager
  },
  data () {
    return {
      baseURL: store.baseURL,
      searchFilter: '',
      comptes: [],
      create: false,
      echec: ''
    }
  },
  watch: {
    async searchFilter (newVal) {
      newVal = newVal || 0
      const url = this.baseURL + newVal + '/_getUsers'
      const response = await axios.get(url)
      this.comptes = response.data
    }
  },
  methods: {
    /**
     * Summary : Crée un compte selon les informations du formulaire.
     */
    async signUp () {
      const form = this.$refs.signUp
      const bodyFormData = new FormData(form)
      if (form.email.value === '' && form.phone.value === '') {
        this.echec = 'la création de compte'
        return
      }
      if (form.password.value !== form.password2.value) {
        this.echec = 'la création de compte, les mots de passe ne sont pas identique'
        return
      }
      const url = this.baseURL + '_createUser'
      const response = await axios.post(url, bodyFormData)
      if (response.data !== false) {
        alert('Création du compte réussie')
        this.refresh('')
      } else {
        this.echec = 'la création de compte, peut-être que ce compte existe déjà'
      }
    },
    /**
     * Summary : Rafraichit le tableau des comptes.
     * @returns : {Array} Liste des comptes
     */
    async refresh (url) {
      this.echec = ''
      if (url === null || url === '') {
        url = this.baseURL + '0' + '/_getUsers'
      }
      const response = await axios.get(url)
      this.comptes = response.data
      return response.data
    }
  },
  mounted () {
    const url = this.baseURL + '0' + '/_getUsers'
    this.refresh(url)
  }
}
</script>

<style scoped>
  table {
    width: 100%;
    border-collapse: collapse;
  }
  td input {
    width: calc(100% - 8px);
  }
  td button {
    width: 100%;
  }
  form {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
  }
  form input[type=text], form input[type=password] {
    padding: 10px;
    border: 1px solid gainsboro;
    border-radius: 16px;
  }
  input {
    width: 250px;
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
</style>
