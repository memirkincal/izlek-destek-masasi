document.addEventListener("click", (event) => {
  const closeButton = event.target.closest("[data-toast-dismiss]");
  if (closeButton) closeButton.closest("[data-toast]")?.remove();

  const draftButton = event.target.closest("[data-reply-draft]");
  if (draftButton) {
    const form = draftButton.closest(".detail-main")?.querySelector("[data-reply-form]");
    const replyBody = form?.querySelector("[data-reply-body]");
    if (!replyBody) return;

    const internalToggle = form.querySelector("[data-internal-reply-toggle]");
    if (internalToggle?.checked) {
      internalToggle.checked = false;
      internalToggle.dispatchEvent(new Event("change", { bubbles: true }));
    }

    replyBody.value = draftButton.dataset.replyDraft || "";
    replyBody.dispatchEvent(new Event("input", { bubbles: true }));
    replyBody.focus();
    replyBody.scrollIntoView({ behavior: "smooth", block: "center" });
  }
});

document.addEventListener("change", (event) => {
  const toggle = event.target.closest("[data-internal-reply-toggle]");
  if (!toggle) return;

  const form = toggle.closest("[data-reply-form]");
  const submit = form?.querySelector("[data-reply-submit]");
  if (submit) submit.value = toggle.checked ? submit.dataset.internalLabel : submit.dataset.publicLabel;
  form?.classList.toggle("reply-form-internal", toggle.checked);
});

document.querySelectorAll("[data-toast]").forEach((toast) => {
  window.setTimeout(() => {
    toast.classList.add("toast-leaving");
    window.setTimeout(() => toast.remove(), 220);
  }, 5200);
});
