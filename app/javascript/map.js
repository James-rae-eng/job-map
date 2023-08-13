/* eslint-disable no-undef */
function initMap(lat, lng) {
  const myCoords = new google.maps.LatLng(lat, lng);
  const mapOptions = { center: myCoords, zoom: 14 };
  const map = new google.maps.Map(document.getElementById('map'), mapOptions);
  // eslint-disable-next-line no-unused-vars
  const marker = new google.maps.Marker({ position: myCoords, map });
}

document.addEventListener('DOMContentLoaded', () => {
  initMap(51.501564, -0.141944);
});
