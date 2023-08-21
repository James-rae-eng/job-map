/* eslint-disable no-undef */
function initMap() {
  // Get scrape variable containing all jobs
  const jobs = gon.scrape;
  // Get the lat & long from jobs, at the moment only getting the first one, CHANGE TO GET ALL OF THEM
  const lat = jobs[0].latlong[0];
  const lng = jobs[0].latlong[1];

  const myCoords = new google.maps.LatLng(lat, lng);
  const mapOptions = { center: myCoords, zoom: 14 };
  const map = new google.maps.Map(document.getElementById('map'), mapOptions);
  // eslint-disable-next-line no-unused-vars
  const marker = new google.maps.Marker({ position: myCoords, map });
}

document.addEventListener('DOMContentLoaded', () => {
  initMap();
});
