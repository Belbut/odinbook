// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("change", (event) => {
  const input = event.target.closest(".file-input");
  if (!input) return;

  const file = input.closest(".file");
  const name = file?.querySelector(".file-name");
  if (!name) return;

  name.textContent =
    input.files.length > 1
      ? `${input.files.length} files selected`
      : input.files[0]?.name || "No file selected";
});