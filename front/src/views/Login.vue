<template>
  <div class="login">
    <img src="../images/peppa.png"/>
    <div id="content" ref="content">
      <h1>Il semblerait que vous ne soyez pas connecté...</h1>
      <h2 v-if="dataStore.panier.length > 0">Connectez-vous pour finaliser votre commande</h2>
      <div v-if="echec !== ''" id="echec">
        <h3>Echec lors de {{ echec }}</h3>
        <h4>Veuillez vérifier vos informations</h4>
      </div>
      <div class="row">
        <div class="column">
          <h3>Je n'ai pas de compte, je m'inscris</h3>
          <form onsubmit="return false;" ref="signUp">
            <label for="name">Nom</label><br/>
            <input type="text" name="name" placeholder="Entrez votre nom" required/><br/><br/>
            <label for="firstname">Prenom</label><br/>
            <input type="text" name="firstname" placeholder="Entrez votre prénom" required/><br/><br/>
            <label for="email">Adresse E-mail</label><br/>
            <input type="text" name="email" placeholder="Entrez votre adresse e-mail"/><br/><br/>
            <label for="phone">Numéro de téléphone</label><br/>
            <input type="text" name="phone" placeholder="Entrez votre numéro de téléphone"/><br/><br/>
            <label for="password">Mot de passe</label><br/>
            <input type="password" name="password" placeholder="Entrez votre mot de passe" required/><br/><br/>
            <label for="password2">Confirmer Mot de passe</label><br/>
            <input type="password" name="password2" placeholder="Réécrivez votre mot de passe" required/><br/><br/>
            <input @click="signUp" type="submit" value="S'inscrire"/>
          </form>
        </div>
        <div class="column">
          <h3>J'ai un compte, je me connecte</h3>
          <form onsubmit="return false;" ref="signIn" enctype="multipart/form-data">
            <label for="username">Adresse E-mail Ou Numéro de téléphone</label><br/>
            <input type="text" name="username" placeholder="Entrez votre identifiant" required/><br/><br/>
            <label for="password">Mot de passe</label><br/>
            <input type="password" name="password" placeholder="Entrez votre mot de passe" required/><br/><br/>
            <input type="submit" @click="signIn" value="Se connecter"/>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { store } from '../store'
import axios from 'axios'
export default {
  name: 'Login',
  data () {
    return {
      echec: '',
      dataStore: store,
      baseURL: store.baseURL
    }
  },
  watch: {
    echec (newVal) {
      if (newVal !== '') {
        this.$refs.content.scrollIntoView({ behavior: 'smooth' })
      }
    }
  },
  methods: {
    /**
     * Summary : Connecte l'utilisateur grâce aux données du formulaire.
     * Description : Initialise les variables de session
     */
    async signIn () {
      const form = this.$refs.signIn
      const bodyFormData = new FormData(form)
      // bodyFormData.append('username', form.username.value.normalize('NFD').replace(/'/g, '').replace(/=/g, '').replace(/--/g, '').replace(/ /g, ''))
      // bodyFormData.append('password', form.password.value)
      const url = this.baseURL + '_connect'
      // const response = await axios({
      //   method: 'post',
      //   url,
      //   data: bodyFormData,
      //   headers: { 'Content-Type': 'multipart/form-data' }
      // })
      const response = await axios.post(url, bodyFormData)
      console.log(response.data)
      if (response.data !== false) {
        sessionStorage.setItem('id', response.data.ID_Utilisateur)
        sessionStorage.setItem('nom', response.data.Nom)
        sessionStorage.setItem('prenom', response.data.Prenom)
        sessionStorage.setItem('numTel', response.data.NumTel)
        sessionStorage.setItem('email', response.data.Email)
        sessionStorage.setItem('isAdmin', response.data.isAdmin)
        if (Number(response.data.isAdmin) === 1 && this.dataStore.panier.length === 0) {
          this.$router.push('/dashboard')
        } else {
          if (this.dataStore.panier.length > 0) {
            this.$router.push('/panier')
          } else {
            this.$router.push('/products')
          }
        }
      } else {
        this.echec = 'la connexion'
      }
    },
    /**
     * Summary : Inscrit l'utilisateur grâce aux données du formulaire.
     * Description : Initialise les variables de session.
     */
    async signUp () {
      const form = this.$refs.signUp
      const bodyFormData = new FormData(form)
      if (form.email.value === '' && form.phone.value === '') {
        this.echec = 'l\'inscription'
        return
      }
      if (form.password.value !== form.password2.value) {
        this.echec = 'l\'inscription, les mots de passe ne sont pas identique'
        return
      }
      const url = this.baseURL + '_createUser'
      const response = await axios.post(url, bodyFormData)
      if (response.data !== 'false') {
        sessionStorage.setItem('id', response.data.ID_Utilisateur)
        sessionStorage.setItem('nom', response.data.Nom)
        sessionStorage.setItem('prenom', response.data.Prenom)
        sessionStorage.setItem('numTel', response.data.NumTel)
        sessionStorage.setItem('email', response.data.Email)
        sessionStorage.setItem('isAdmin', response.data.isAdmin)
        if (Number(response.data.isAdmin) === 1) {
          this.$router.push('/')
        } else {
          if (this.dataStore.panier.length > 0) {
            this.$router.push('/panier')
          } else {
            this.$router.push('/products')
          }
        }
      } else {
        this.echec = 'l\'inscription, peut-être que ce compte existe déjà'
      }
    }
  }
}
</script>

<style scoped>
  .login {
    margin-bottom: 10vh;
  }
  #echec {
    width: 100vw;
    background-color: #f04c4c;
    color: white;
    padding-top: 1px;
    padding-bottom: 1px;
  }
  label, input, h1, h2, h3 {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  img:nth-of-type(1) {
    width: 100vw;
    height: 30vh;
  }
  input[type=text], input[type=password] {
    width: calc(100% - 20px);
    border: 1px solid gainsboro;
    border-radius: 16px;
    padding: 10px;
  }
  input[type='submit'] {
    border: none;
    padding: 3px 9px;
    text-decoration: none;
    color: white;
    background-color: #f04c4c;
    border-radius: 8px;
    text-align: center;
    cursor: pointer;
    font-size: 16px;
    width: 100%;
    padding: 10px;
  }
  .content {
    display: flex;
    width: 100vw;
    flex-direction: column;
    justify-content: flex-start;
    align-items: center;
  }
  .row {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: flex-start;
    width: 100vw;
  }
  .column {
    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    width: 50vw;
  }
  .column form {
    text-align: left;
    width: 50%;
  }
</style>
