export const ClickOutside = {
  id() {
    return this.el.dataset.id;
  },
  event() {
    return this.el.dataset.event;
  },
  mounted() {
    document.addEventListener(
      "click",
      (event) => {
        if (!event.target.closest(`#${this.el.id}`)) {
          this.pushEventTo(`#${this.id()}`, this.event(), {});
        }
      },
      false
    );
  },
};
