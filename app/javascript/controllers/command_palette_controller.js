import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "item"];

  connect() {
    this._activeIndex = -1;
    this._debounceTimer = null;
    this._boundGlobalKey = this._globalKey.bind(this);
    document.addEventListener("keydown", this._boundGlobalKey);
    this.element.addEventListener("turbo:frame-render", () => {
      this._activeIndex = -1;
      this._clearActive();
    });
  }

  disconnect() {
    document.removeEventListener("keydown", this._boundGlobalKey);
    clearTimeout(this._debounceTimer);
  }

  _globalKey(event) {
    const trigger = navigator.platform.toUpperCase().includes("MAC")
      ? event.metaKey
      : event.ctrlKey;
    if (trigger && event.key === "k") {
      event.preventDefault();
      this.element.showModal();
      this.inputTarget.select();
    }
  }

  close() {
    this.element.close();
    this._activeIndex = -1;
    this._clearActive();
  }

  handleCancel(event) {
    event.preventDefault();
    this.close();
  }

  backdropClick(event) {
    const rect = this.element.getBoundingClientRect();
    const inside =
      event.clientX >= rect.left &&
      event.clientX <= rect.right &&
      event.clientY >= rect.top &&
      event.clientY <= rect.bottom;
    if (!inside) this.close();
  }

  scheduleSubmit() {
    clearTimeout(this._debounceTimer);
    this._debounceTimer = setTimeout(() => {
      this.element.querySelector("form").requestSubmit();
    }, 150);
  }

  handleKey(event) {
    switch (event.key) {
      case "ArrowDown":
        event.preventDefault();
        this._move(1);
        break;
      case "ArrowUp":
        event.preventDefault();
        this._move(-1);
        break;
      case "Enter":
        event.preventDefault();
        this._activate();
        break;
      case "Escape":
        this.close();
        break;
    }
  }

  highlight(event) {
    const i = this.itemTargets.indexOf(event.currentTarget);
    if (i !== -1) {
      this._activeIndex = i;
      this._applyActive();
    }
  }

  select(event) {
    const path = event.currentTarget.dataset.path;
    if (path) {
      this.close();
      window.Turbo.visit(path);
    }
  }

  _move(dir) {
    const items = this.itemTargets;
    if (!items.length) return;
    this._activeIndex = Math.max(
      0,
      Math.min(items.length - 1, this._activeIndex + dir),
    );
    this._applyActive();
  }

  _activate() {
    const item = this.itemTargets[this._activeIndex];
    if (item?.dataset.path) {
      this.close();
      window.Turbo.visit(item.dataset.path);
    }
  }

  _applyActive() {
    this._clearActive();
    const item = this.itemTargets[this._activeIndex];
    if (item) {
      item.classList.add("command-palette__item--active");
      item.scrollIntoView({ block: "nearest" });
      this.inputTarget.setAttribute("aria-activedescendant", item.id);
    }
  }

  _clearActive() {
    this.itemTargets.forEach((el) =>
      el.classList.remove("command-palette__item--active"),
    );
    if (this.hasInputTarget)
      this.inputTarget.setAttribute("aria-activedescendant", "");
  }
}
