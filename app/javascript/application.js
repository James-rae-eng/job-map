// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import '@hotwired/turbo-rails';
import 'controllers';

//= require turbolinks
//= require bootstrap
//= require_tree.

//= require js-routes

// Enable or disable advanced search
const checkbox = document.getElementById('advanced');
const extraSearch = document.getElementById('extra_search');
// eslint-disable-next-line func-names
checkbox.onchange = function () {
  if (this.checked) {
    extraSearch.style.display = 'flex';
  } else {
    extraSearch.style.display = 'none';
  }
};

// Make sure salary max dropdown always has a higher value than salary min dropdown
const salaryMin = document.getElementById('salaryMin');
const salaryMax = document.getElementById('salaryMax').getElementsByTagName('option');
// eslint-disable-next-line func-names
salaryMin.onchange = function () {
  const minIndex = salaryMin.selectedIndex;
  for (let i = 0; i < salaryMax.length; i += 1) {
    if (i < minIndex) {
      salaryMax[i].disabled = true;
    } else {
      salaryMax[i].disabled = false;
    }
  }
};
