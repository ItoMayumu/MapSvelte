<script lang="ts">
  import Map from './Map.svelte';
  export let ready;
</script>

<svelte:head>
    <script
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBW1GMn5PowT_qtP5S63mbnioyABdd_y-I&libraries=drawing&callback=initMap&v=weekly"
    defer
  ></script>
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
