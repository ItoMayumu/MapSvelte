<script lang="ts">
  import { onMount } from "svelte";

  let container: HTMLElement;
  let map: google.maps.Map;
  const mapId = "48d8979b650d798d"; // GCPのmapId

  async function initMap() {
    const map = new google.maps.Map(
      document.getElementById("map") as HTMLElement,
      {
        zoom: 7,
        center: { lat: 41.85, lng: -87.65 },
      }
    );

    const directionsService = new google.maps.DirectionsService();
    const directionsRenderer = new google.maps.DirectionsRenderer({
    draggable: true,
    map,
    panel: document.getElementById("panel") as HTMLElement,
  });

     directionsRenderer.addListener("directions_changed", () => {
    const directions = directionsRenderer.getDirections();

    if (directions) {
      computeTotalDistance(directions);
    }
  });

  displayRoute(
   "Tokyo, Japan",
    "Osaka, Japan",
    directionsService,
    directionsRenderer
  );
}

function displayRoute(
  origin: string,
  destination: string,
  service: google.maps.DirectionsService,
  display: google.maps.DirectionsRenderer
) {
  service
    .route({
      origin: origin,
      destination: destination,
      // waypoints: [
      //   { location: "Adelaide, SA" },
      //   { location: "Broken Hill, NSW" },
      // ],
      travelMode: google.maps.TravelMode.DRIVING,
      avoidTolls: true,
    })
    .then((result: google.maps.DirectionsResult) => {
      display.setDirections(result);
    })
    .catch((e) => {
      alert("Could not display directions due to: " + e);
    });
}

function computeTotalDistance(result: google.maps.DirectionsResult) {
  let total = 0;
  const myroute = result.routes[0];

  if (!myroute) {
    return;
  }

  for (let i = 0; i < myroute.legs.length; i++) {
    total += myroute.legs[i]!.distance!.value;
  }

  total = total / 1000;
  (document.getElementById("total") as HTMLElement).innerHTML = total + " km";
}

//     const onChangeHandler = function () {
//     calculateAndDisplayRoute(directionsService, directionsRenderer);
//   };

//   (document.getElementById("start") as HTMLElement).addEventListener(
//     "change",
//     onChangeHandler
//   );
//   (document.getElementById("end") as HTMLElement).addEventListener(
//     "change",
//     onChangeHandler
//   );
// }
    
// function calculateAndDisplayRoute(
//   directionsService: google.maps.DirectionsService,
//   directionsRenderer: google.maps.DirectionsRenderer
// ) {
//   directionsService
//     .route({
//       origin: {
//         query: (document.getElementById("start") as HTMLInputElement).value,
//       },
//       destination: {
//         query: (document.getElementById("end") as HTMLInputElement).value,
//       },
//       travelMode: google.maps.TravelMode.DRIVING,
//     })
//     .then((response) => {
//       directionsRenderer.setDirections(response);
//       console.log(response);
//     })
//     .catch((e) => window.alert("Directions request failed due to " + status));
// }

  onMount(async () => {
    try {
      await initMap();
    } catch (error) {
      console.error("err: ", error);
    }
  });
</script>

<!-- // <div>
//     <div id="floating-panel">
//         <b>Start: </b>
//         <select id="start">
//           <option value="chicago, il">Chicago</option>
//           <option value="st louis, mo">St Louis</option>
//           <option value="joplin, mo">Joplin, MO</option>
//           <option value="oklahoma city, ok">Oklahoma City</option>
//           <option value="amarillo, tx">Amarillo</option>
//           <option value="gallup, nm">Gallup, NM</option>
//           <option value="flagstaff, az">Flagstaff, AZ</option>
//           <option value="winona, az">Winona</option>
//           <option value="kingman, az">Kingman</option>
//           <option value="barstow, ca">Barstow</option>
//           <option value="san bernardino, ca">San Bernardino</option>
//           <option value="los angeles, ca">Los Angeles</option>
//         </select>
//         <b>End: </b>
//         <select id="end">
//           <option value="chicago, il">Chicago</option>
//           <option value="st louis, mo">St Louis</option>
//           <option value="joplin, mo">Joplin, MO</option>
//           <option value="oklahoma city, ok">Oklahoma City</option>
//           <option value="amarillo, tx">Amarillo</option>
//           <option value="gallup, nm">Gallup, NM</option>
//           <option value="flagstaff, az">Flagstaff, AZ</option>
//           <option value="winona, az">Winona</option>
//           <option value="kingman, az">Kingman</option>
//           <option value="barstow, ca">Barstow</option>
//           <option value="san bernardino, ca">San Bernardino</option>
//           <option value="los angeles, ca">Los Angeles</option>
//         </select>
//       </div> -->
  <div id="map" class="full-screen" bind:this={container}></div>
<!-- </div> -->

<style>
  .full-screen {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  #floating-panel {
  position: absolute;
  top: 10px;
  left: 25%;
  z-index: 5;
  background-color: #fff;
  padding: 5px;
  border: 1px solid #999;
  text-align: center;
  font-family: "Roboto", "sans-serif";
  line-height: 30px;
  padding-left: 10px;
}

</style>
