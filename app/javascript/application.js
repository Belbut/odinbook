// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
  const input = document.querySelector(".file-input");

  if (input) {
    input.onchange = function () {
      const name = this.closest(".file").querySelector(".file-name");

      name.textContent =
        this.files.length > 1
          ? this.files.length + " files selected"
          : this.files[0]?.name || "No file selected";
    };
  }
});