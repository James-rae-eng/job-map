/* eslint-disable no-undef */
function initMap() {
  // Get scrape variable containing all jobs
  const jobs = gon.scrape;

  // Set up map and centre on first job in list
  const firstCoords = new google.maps.LatLng(jobs[0].latlong[0], jobs[0].latlong[1]);
  const mapOptions = { center: firstCoords, zoom: 9 };
  const map = new google.maps.Map(document.getElementById('map'), mapOptions);
  // eslint-disable-next-line no-unused-vars

  // Create infowindow to be filled with content as a marker is clicked
  const infowindow = new google.maps.InfoWindow();

  // Add markers for each job
  for (let i = 0; i < jobs.length; i += 1) {
    // Add markers to the jobs
    const coords = new google.maps.LatLng(jobs[i].latlong[0], jobs[i].latlong[1]);
    const marker = new google.maps.Marker({ position: coords, map });

    // Deal with infowindow content & event listener for each marker
    google.maps.event.addListener(marker, 'click', () => {
      infowindow.setContent(
        `<p>${jobs[i].title}</p>`
      + `<p>${jobs[i].location}</p>`
      + `<p>${jobs[i].salary}</p>`
      + `<a href=${jobs[i].link} target="_blank">${jobs[i].link}</a>`,
      );
      infowindow.open(map, marker);
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  initMap();
});
