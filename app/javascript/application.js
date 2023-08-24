// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

const checkbox = document.getElementById('advanced');
const extraSearch = document.getElementById('extra_search');
// eslint-disable-next-line func-names
checkbox.onchange = function () {
  if (this.checked) {
    extraSearch.style.display = 'block';
  } else {
    extraSearch.style.display = 'none';
  }
};
