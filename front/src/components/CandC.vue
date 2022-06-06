<template>
  <div id="button">
    <div id="buttonChild">
      <span>
        <h3>Réservez votre panier</h3>
        <h3>MAINTENANT</h3>
      </span>
      <router-link to="/products">
        <div id="shopping-bag">
          <div id="handle"></div>
          <div id="bag"></div>
        </div>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CandC'
}
</script>

<style scoped>
  h3 {
    text-align: center;
    color: white;
  }
  #button {
    display: flex;
    justify-content: center;
    align-items: center;
    min-width: 33vw;
    height: 100vh;
    background: linear-gradient(0.25turn, #F05D5E,#FF0000);
  }
  #shopping-bag:hover {
    border-bottom: 5px solid #666;
    transform: translateY(4px) scale(1.5);;
    border-color: gainsboro;
  }
  #shopping-bag {
    width: fit-content;
    max-height: 33vh;
    cursor: pointer;
    outline: none;
    color: #fff;
    border: none;
    border-bottom: 9px solid #999;
    border-radius: 0;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    transform: scale(1.5);
  }

  #handle {
    border: 5px solid;
    border-color: white;
    border-radius: 50%;
    width: 50px;
    height: 50px;
  }
  #bag {
    margin-top: -30px;
    display: inline-block;
    border-bottom: 100px solid;
    border-left: 8px solid transparent;
    border-right: 8px solid transparent;
    border-bottom-color: white;
    width: 100px;
    height: 0;
  }
  #buttonChild {
    height: 50vh;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    align-items: center;
  }
</style>
