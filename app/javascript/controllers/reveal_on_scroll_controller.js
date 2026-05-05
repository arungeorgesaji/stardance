import { Controller } from "@hotwired/stimulus";

// Adds a gentle rise+fade to section titles and body content as they enter
// the viewport. One-shot per element (unobserves after reveal). Skips the
// hero — that has its own warp-in choreography.
//
// Targets are auto-collected by CSS selector so section ERB files stay clean.
// Any element within the controller's scope matching `REVEAL_SELECTORS` is
// prepped with `.reveal` and revealed when it intersects.
const REVEAL_SELECTORS = [
  ".heres-how__title",
  ".heres-how__repeat",
  ".prizes__text",
  ".project-outcome__title",
  ".project-outcome__stage",
  ".weekend__title",
  ".weekend__subtitle",
  ".weekend__items",
  ".weekend__coding",
  ".what-is-this__title",
  ".what-is-this__body",
  ".done-before__title",
  ".done-before__subtitle",
  ".done-before__cards",
  ".faq-section__title",
  ".faq-section__list",
  ".cta-section__title",
  ".cta-section__subtitle",
  ".cta-section__form",
];

// Divider wrappers reveal with their own choreography (sparkles → line) — see
// .divider-reveal in _reveal.scss. The .what-is-this__divider is handled by
// the warp cascade on first paint, so it's intentionally excluded.
const DIVIDER_REVEAL_SELECTORS = [
  ".heres-how__divider",
  ".weekend__divider",
  ".done-before__border--top",
  ".done-before__border--bottom",
];

export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
    if (typeof IntersectionObserver === "undefined") return;

    const targets = this.element.querySelectorAll(REVEAL_SELECTORS.join(","));
    const dividerTargets = this.element.querySelectorAll(
      DIVIDER_REVEAL_SELECTORS.join(","),
    );
    if (targets.length === 0 && dividerTargets.length === 0) return;

    for (const el of targets) el.classList.add("reveal");
    for (const el of dividerTargets) el.classList.add("divider-reveal");

    this.io = new IntersectionObserver(
      (entries) => {
        for (const entry of entries) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-revealed");
            this.io.unobserve(entry.target);
          }
        }
      },
      { threshold: 0.12, rootMargin: "0px 0px -8% 0px" },
    );

    for (const el of targets) this.io.observe(el);
    for (const el of dividerTargets) this.io.observe(el);
  }

  disconnect() {
    this.io?.disconnect();
  }
}
