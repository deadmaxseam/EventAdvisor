// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

$(document).ready(function() {
  $(".registration-button").click(function() {
    $(".modal").css("display", "block");
  });

  $(".close").click(function() {
    $(".modal").css("display", "none");
  });
});

