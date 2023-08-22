/* eslint-disable no-undef */
function initMap() {
  // Get scrape variable containing all jobs
  const jobs = gon.scrape;

  // Set up map and centre on first job in list
  const firstCoords = new google.maps.LatLng(jobs[0].latlong[0], jobs[0].latlong[1]);
  const mapOptions = { center: firstCoords, zoom: 14 };
  const map = new google.maps.Map(document.getElementById('map'), mapOptions);
  // eslint-disable-next-line no-unused-vars
  // const marker = new google.maps.Marker({ position: firstCoords, map });

  // Add markers for each job
  for (let i = 0; i < jobs.length; i += 1) {
    const coords = new google.maps.LatLng(jobs[i].latlong[0], jobs[i].latlong[1]);
    jobs[i].marker = new google.maps.Marker({ position: coords, map });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  initMap();
});
