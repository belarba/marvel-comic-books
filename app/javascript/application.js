// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll('.favorite-btn').forEach(button => {
    button.addEventListener('click', (event) => {
      event.preventDefault();

      const url = button.getAttribute('href');
      const method = button.getAttribute('data-method') || 'post';
      const comicId = button.closest('.favorite-button').dataset.comicId;

      fetch(url, {
        method: method,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        const iconElement = document.getElementById(`favorite-icon-${comicId}`);

        if (iconElement) {
          iconElement.src = `/assets/${data.icon}`;
        } else {
          console.error("Icon element not found for comic ID:", comicId);
        }
      })
      .catch(error => {
        console.error("Failed to favorite comic:", error);
      });
    });
  });
});
