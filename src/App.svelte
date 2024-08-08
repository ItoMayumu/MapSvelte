<script lang="ts">
  import Map from './Map.svelte';
  import Map2 from './Map2.svelte';
  export let ready;
</script>

<svelte:head>
    <script
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAxFyaxgO1edLSwqpUq1c0mBI8Zn4iHqcM&libraries=drawing&callback=initMap&v=weekly"
    defer
  ></script>
</svelte:head>

<main>
  {#if ready}
    <Map2 />
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
