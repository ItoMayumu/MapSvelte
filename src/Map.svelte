<script lang="ts">
  import { onMount } from "svelte";
  import { Loader } from "@googlemaps/js-api-loader";
  import { writable, get } from "svelte/store";

  let container: HTMLElement;
  let map: google.maps.Map;
  let featureLayer: google.maps.FeatureLayer;
  let infoWindow: google.maps.InfoWindow;
  let markers: google.maps.Marker;
  let centerPosition: { lat: number; lng: number } | undefined;
  const mapId = "48d8979b650d798d"; // GCPのmapId
  let placeIdList: string[] = [];
  let radius=0;



  onMount(async () => {
    const loader = new Loader({
      apiKey: "AIzaSyAxFyaxgO1edLSwqpUq1c0mBI8Zn4iHqcM",
      version: "weekly",
    });

    const { Map } = (await loader.importLibrary(
      "maps"
    )) as google.maps.MapsLibrary;

    map = new Map(container, {
      center: { lat: 34.7, lng: 135.5 }, // Park County, CO
      zoom: 14,
      mapId: mapId,
    });

    //@ts-ignore
    featureLayer = map.getFeatureLayer("POSTAL_CODE");

    infoWindow = new google.maps.InfoWindow({});

    const drawingManager = new google.maps.drawing.DrawingManager({
      drawingControl: true,
      drawingControlOptions: {
        position: google.maps.ControlPosition.TOP_CENTER,
        drawingModes: [google.maps.drawing.OverlayType.POLYGON],
      },
      polygonOptions: {
        fillColor: "#FFD700",
        fillOpacity: 0.2,
        strokeColor: "#FFD700",
        strokeOpacity: 1,
        strokeWeight: 4,
        clickable: false,
        editable: false,
        zIndex: 1,
      },
    });

    drawingManager.setMap(map);

    applyStyleToSelected();

    google.maps.event.addListener(
      drawingManager,
      "polygoncomplete",
      function (polygon) {
        let maxXList = -Infinity;
        let maxYList = -Infinity;
        let minXList = Infinity;
        let minYList = Infinity;
        let polygonPath = polygon.getPath();

        polygonPath.forEach((value, ii) => {
          const currentLat = polygonPath.getAt(ii).lat();
          const currentLng = polygonPath.getAt(ii).lng();
          if (maxXList < currentLat) {
            maxXList = currentLat;
          }
          if (minXList > currentLat) {
            minXList = currentLat;
          }
          if (maxYList < currentLng) {
            maxYList = currentLng;
          }
          if (minYList > currentLng) {
            minYList = currentLng;
          }
        });
        centerPosition = {
          lat: (maxXList + minXList) / 2,
          lng: (maxYList + minYList) / 2,
        };
        if (!centerPosition) {
          return;
        }
        radius = Math.abs(maxXList - centerPosition.lat)*11000*1000 ;
        console.log(radius)
        // ポリゴンが完成したらnearbySearch関数を呼び出す
        nearbySearch();
      }
    );
  });

  async function nearbySearch() {
    //@ts-ignore
    const { Place, SearchNearbyRankPreference } =
      (await google.maps.importLibrary("places")) as google.maps.PlacesLibrary;
    const { AdvancedMarkerElement } = (await google.maps.importLibrary(
      "marker"
    )) as google.maps.MarkerLibrary;

    const centerPos = centerPosition;
    if (!centerPos) return;

    let center = new google.maps.LatLng(centerPos.lat, centerPos.lng);

    const request = {
      fields: ["displayName", "location", "businessStatus"],
      locationRestriction: {
        center: center,
        radius,
      },
      includedPrimaryTypes: ["postal_code"],
      maxResultCount: 20,
      rankPreference: SearchNearbyRankPreference.POPULARITY,
      language: "en-US",
      region: "us",
    };

    const { places } = await Place.searchNearby(request);

    if (places.length) {
      const { LatLngBounds } = (await google.maps.importLibrary(
        "core"
      )) as google.maps.CoreLibrary;
      const bounds = new LatLngBounds();
      placeIdList = [];
      places.forEach((place) => {
        const markerView = new AdvancedMarkerElement({
          map,
          position: place.location,
          title: place.displayName,
        });
        bounds.extend(place.location as google.maps.LatLng);
        placeIdList.push(place.id);
      });
      console.log(placeIdList);

      map.fitBounds(bounds);
    } else {
      console.log("No results");
    }
  }

  const styleDefault: google.maps.FeatureStyleOptions = {
    strokeOpacity: 1.0,
    strokeWeight: 2.0,
    fillColor: "white",
    fillOpacity: 0.1,
  };

  //@ts-ignore
  const styleClicked: google.maps.FeatureStyleOptions = {
    ...styleDefault,
    fillColor: "#810FCB",
    fillOpacity: 0.5,
  };

  function applyStyleToSelected() {
    featureLayer.style = (options) => {
      if (
        placeIdList &&
        placeIdList.some((placeid) => options.feature.placeId == placeid)
      ) {
        return styleClicked;
      }
      return styleDefault;
    };
  }

  function updateInfoWindow(
    content: string | Element | Text | null | undefined,
    center: google.maps.LatLng | google.maps.LatLngLiteral | null | undefined
  ) {
    infoWindow.setContent(content);
    infoWindow.setPosition(center);
    infoWindow.open({
      map,
      shouldFocus: false,
    });
  }
</script>

<div class="full-screen" bind:this={container}></div>

<style>
  .full-screen {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }
</style>
