<template>
  <tr>
    <td>{{ Nom }}</td>
    <td>{{ Prenom }}</td>
    <td>{{ Email }}</td>
    <td>{{ NumTel }}</td>
    <td><input type="text" v-model="newMDP" placeholder="*******"/></td>
    <td><button @click="modifMDP">Valider</button></td>
    <td><button @click="supprCompte">Supprimer</button></td>
  </tr>
</template>

<script>
import axios from 'axios'
import { store } from '../store'
export default {
  name: 'CompteManager',
  data () {
    return {
      newMDP: '',
      baseURL: store.baseURL
    }
  },
  props: {
    ID_Compte: Number,
    Nom: String,
    Prenom: String,
    Email: String,
    NumTel: String
  },
  methods: {
    /**
     * Summary : Permet de modifier le mot de passe du compte.
     */
    async modifMDP () {
      console.log(this.ID_Compte)
      const bodyFormData = new FormData()
      bodyFormData.append('userID', this.ID_Compte)
      bodyFormData.append('newMDP', this.newMDP)
      const url = this.baseURL + '_modifMDP'
      const response = await axios.post(url, bodyFormData)
      if (response.data === true) {
        alert('Changement de mot de passe réussi')
      } else {
        alert('Echec du changement de mot de passe')
      }
    },
    /**
     * Summary : Permet de supprimer le compte.
     */
    async supprCompte () {
      const cfm = confirm('Etes vous sûr de vouloir supprimer ce compte ?')
      if (!cfm) return
      const url = this.baseURL + this.ID_Compte + '/_deleteUser'
      const response = await axios.get(url)
      if (response.data === true) {
        alert('Suppression du compte réussie')
        this.$emit('refresh', '')
      } else {
        alert('Echec de la suppression du compte')
      }
    }
  }
}
</script>

<style scoped>
  td input {
    width: calc(100% - 8px);
  }
  td button {
    width: 100%;
  }
</style>
