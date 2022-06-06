<template>
  <div id="info">
    <div id="infoChild">
      <pre id="datas">
    Ouverture:
    <span>Mardi-Vendredi: 8:00-12:30 16:00-19:30
     Samedi: 8:00-12:45 16:00-19:45
    </span>

    Informations complémentaires:
      Adresse: 27 Place Sébastopol 13004 Marseille
      Numéro: 04 91 34 15 21
      Gérant: M. Giroud Christophe
      </pre>
      <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2903.7348087265536!2d5.395730814649378!3d43.298874983289494!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x12c9bf60a0123e57%3A0xa581fa36b73b2392!2s27%20Pl.%20S%C3%A9bastopol%2C%2013004%20Marseille!5e0!3m2!1sfr!2sfr!4v1641547940807!5m2!1sfr!2sfr" width="100%" height="70%" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Info'
}
</script>

<style scoped>
  #datas {
    text-align: left;
    color: white;
    height: 25%;
  }
  #info {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    width: 34vw;
    background: linear-gradient(0.25turn,#bb9a9a, #F05D5E);
  }
  #infoChild {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    width: 30vw;
  }
  span {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    height: fit-content;
  }
</style>
