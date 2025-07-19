// Copyright (C) 2025 Zachary Bensley
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "dropdown" ]

  connect() {
    this._onTransitionEnd = this._onTransitionEnd.bind(this)
  }

  toggle() {
    if (this.dropdownTarget.classList.contains("opacity-0")) {
      this._show()
    } else {
      this._hide()
    }
  }

  _show() {
    this._addTransitionClasses("ease-out", "duration-100")
    requestAnimationFrame(() => {
      this.dropdownTarget.classList.remove("opacity-0", "scale-95")
      this.dropdownTarget.classList.add("opacity-100", "scale-100")
    })
    this.dropdownTarget.addEventListener("transitionend", this._onTransitionEnd)
  }

  _hide() {
    this._addTransitionClasses("ease-in", "duration-75")
    requestAnimationFrame(() => {
      this.dropdownTarget.classList.remove("opacity-100", "scale-100")
      this.dropdownTarget.classList.add("opacity-0", "scale-95")
    })
    this.dropdownTarget.addEventListener("transitionend", this._onTransitionEnd)
  }

  _addTransitionClasses(easing, duration) {
    this.dropdownTarget.classList.add(
        "transition",
        easing,
        duration,
        "transform"
    )
  }

  _onTransitionEnd(event) {
    // only care about opacity finishing
    if (event.propertyName !== "opacity") return

    this.dropdownTarget.removeEventListener("transitionend", this._onTransitionEnd)
    this.dropdownTarget.classList.remove(
        "transition",
        "ease-out",
        "duration-100",
        "ease-in",
        "duration-75",
        "transform"
    )
  }
}
