import { Controller } from "@hotwired/stimulus";

// Translates layered elements vertically on page scroll to create a depth
// effect. Each layer's data-speed attribute controls how much it resists
// the scroll: 0 = moves normally with the page, 1 = stays fixed on screen.
export default class extends Controller {
  static targets = ["layer"];

  connect() {
    this.ticking = false;
    this.onScroll = this.onScroll.bind(this);
    window.addEventListener("scroll", this.onScroll, { passive: true });
    this.update();
  }

  disconnect() {
    window.removeEventListener("scroll", this.onScroll);
  }

  onScroll() {
    if (this.ticking) return;
    this.ticking = true;
    window.requestAnimationFrame(() => {
      this.update();
      this.ticking = false;
    });
  }

  update() {
    const scrollY = window.scrollY;
    this.layerTargets.forEach((layer) => {
      const speed = parseFloat(layer.dataset.speed || "0");
      layer.style.transform = `translate3d(0, ${scrollY * speed}px, 0)`;
    });
  }
}
