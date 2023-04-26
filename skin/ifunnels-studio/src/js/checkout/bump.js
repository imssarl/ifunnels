export default class Bump {
  constructor() {}

  static init(element) {
    let memberships = [];

    if (element.getAttribute("data-bump")) {
      memberships = JSON.parse(element.getAttribute("data-bump-list")) || [];
    }

    window.bump = memberships;
  }
}
