<script lang="ts">
    import { onMount } from 'svelte';
    import { Loader } from '@googlemaps/js-api-loader';

    let container: HTMLElement;
    let map: google.maps.Map;
    let featureLayer: google.maps.FeatureLayer;
    let infoWindow: google.maps.InfoWindow;

    const mapId = '48d8979b650d798d'; // <YOUR_MAP_ID_HERE>

    onMount(async () => {
        const loader = new Loader({
            apiKey: "AIzaSyAxFyaxgO1edLSwqpUq1c0mBI8Zn4iHqcM",
            version: 'weekly'
        });

        const { Map } = await loader.importLibrary('maps');

        map = new Map(container, {
            center: { lat: 39.23, lng: -105.73 }, // Park County, CO
            zoom: 8,
            mapId: mapId
        });

        // Add the feature layer.
        //@ts-ignore
        featureLayer = map.getFeatureLayer('POSTAL_CODE');
        // Add the event listener for the feature layer.
        featureLayer.addListener('click', handlePlaceClick);
        infoWindow = new google.maps.InfoWindow({});
        // Apply style on load, to enable clicking.
        applyStyleToSelected();
    });

    // Handle the click event.
    async function handlePlaceClick(event: { features: any[]; latLng: any; }) {
        let feature = event.features[0];
        if (!feature.placeId) return;
        // Apply the style to the feature layer.
        applyStyleToSelected(feature.placeId);
        // Add the info window.
        const place = await feature.fetchPlace();
        let content = '<span style="color: black; font-size:small">Display name: ' + place.displayName +
            '<br/> Place ID: ' + feature.placeId +
            '<br/> Feature type: ' + feature.featureType +
            '</span>';
        updateInfoWindow(content, event.latLng);
    }

    // Stroke and fill with minimum opacity value.
    //@ts-ignore
    const styleDefault: google.maps.FeatureStyleOptions = {
        // strokeColor: '#810FCB',
        // strokeOpacity: 1.0,
        // strokeWeight: 2.0,
        fillColor: 'white',
        fillOpacity: 0.002 // Polygons must be visible to receive click events.
    };

    // Style for the clicked Administrative Area Level 2 polygon.
    //@ts-ignore
    const styleClicked: google.maps.FeatureStyleOptions = {
        strokeColor: '#810FCB',
        strokeOpacity: 1.0,
        strokeWeight: 2.0,
        fillColor: '#810FCB',
        fillOpacity: 0.5
    };

    // Apply styles to the map.
    function applyStyleToSelected(placeid?) {
        // Apply styles to the feature layer.
        featureLayer.style = (options) => {
            // Style fill and stroke for a polygon.
            if (placeid && options.feature.placeId == placeid) {
                return styleClicked;
            }
            // Style only the stroke for the entire feature type.
            return styleDefault;
        };
    }

    // Helper function to create an info window.
    function updateInfoWindow(content: string | Element | Text | null | undefined, center: google.maps.LatLng | google.maps.LatLngLiteral | null | undefined) {
        infoWindow.setContent(content);
        infoWindow.setPosition(center);
        infoWindow.open({
            map,
            shouldFocus: false,
        });
    }
</script>

<style>
.full-screen {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
}
</style>

<div class="full-screen" bind:this={container}></div>
