<script lang="ts">
  import Map from './Map.svelte';
  export let ready;
</script>

<svelte:head>
  <script defer async
    src='https://maps.googleapis.com/maps/api/js?key=AIzaSyAxFyaxgO1edLSwqpUq1c0mBI8Zn4iHqcM&callback=initMap'></script>
</svelte:head>

<main>
  {#if ready}
    <Map />
  {/if}
</main>

<style>
  main {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    width: 100%;
    margin: 0;
  }
</style>
