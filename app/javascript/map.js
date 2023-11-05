/* eslint-disable camelcase */
/* eslint-disable no-undef */

// import { jobs_path } from './routes';
// import { addJob_jobs_path } from './routes';

// send ajax request to server to save job to database
function sendIndex(index) {
  const httpRequest = new XMLHttpRequest();
  httpRequest.open('POST', `http://localhost:3000/jobs/${index}/addJob`);
  httpRequest.send();
}

// Check cookies to see if user is signed in, return true if they are, false otherwise
function signedIn() {
  if (document.cookie.indexOf('signed_in') > -1) {
    return true;
  }
  return false;
}

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

  // Array to track latlongs to make sure there are no duplicate locations
  const allCoords = [];

  // Add markers for each job
  for (let i = 0; i < jobs.length; i += 1) {
    // Add markers to the jobs
    const testCoords = [jobs[i].latlong[0], jobs[i].latlong[1]];
    // if marker location same as a previous job, move its longitude (no overlapping markers)
    if (allCoords.some((item) => item.includes(testCoords[1]))) {
      testCoords[1] = jobs[i].latlong[1] + 0.005;
    }
    allCoords.push(testCoords);
    const coords = new google.maps.LatLng(testCoords[0], testCoords[1]);
    const marker = new google.maps.Marker({ position: coords, map });

    // Deal with infowindow content & event listener for each marker
    google.maps.event.addListener(marker, 'click', () => {
      infowindow.setContent(
        `<p>${jobs[i].title}</p>`
      + `<p>${jobs[i].location}</p>`
      + `<p>${jobs[i].salary}</p>`
      + `<a href=${jobs[i].link} target="_blank">${jobs[i].link}</a>`
      + '<br><br>'
      // eslint-disable-next-line no-template-curly-in-string
      + `<button id="saveBtn" value=${i}>Save</button>`,
      );
      infowindow.open(map, marker);
    });
  }

  // Save job button
  google.maps.event.addListener(infowindow, 'domready', () => {
    google.maps.event.addDomListener(document.getElementById('saveBtn'), 'click', () => {
      const btn = document.getElementById('saveBtn');
      const index = btn.value;
      if (signedIn() === true) {
        sendIndex(index);
      } else {
        alert('Unable to save Job. You must be signed in to save.');
      }
    });
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initMap();
});
