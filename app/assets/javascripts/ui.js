document.addEventListener("click", (event) => {
  const closeButton = event.target.closest("[data-toast-dismiss]");
  if (closeButton) closeButton.closest("[data-toast]")?.remove();
});

document.querySelectorAll("[data-toast]").forEach((toast) => {
  window.setTimeout(() => {
    toast.classList.add("toast-leaving");
    window.setTimeout(() => toast.remove(), 220);
  }, 5200);
});
