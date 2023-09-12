// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails';
import 'controllers';
import "chartkick"
import "Chart.bundle"
import 'flowbite';

// You might need this to make surethe nav drawer always fires
// but it might be better to just use the data-turbo-permanent attribute??
// document.addEventListener("turbo:load", function() {
//   document.querySelector("nav").addEventListener("turbo:click", function() {
//     document.querySelector("nav").classList.toggle("active");
//   });
// });

// The session delete path is not working with this set to false - nav vs log out?
Turbo.session.drive = false;
