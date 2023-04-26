import URI from "urijs";
import axios from "axios";

/** Getting token from server
 *
 * @param [object] - Object of parameters with request url, uid
 * @return [Promise]
 */
export const getToken = ({ request_url, uid }) => {
  return axios.post(request_url, { uid }, { responseType: "json" });
};

/** Getting token from url
 *
 * @return {string or null}
 */
export const getTokenFromURL = () => {
  const { token } = URI(window.location.href).search(true);
  return token || null;
};

/** Adding the token parameter to the url of all links
 *
 * @param [object] - Object with token parameter
 * @void
 */
export const setTokenOnLinks = ({ token }) => {
  document.querySelectorAll("a").forEach((a) => {
    const href = a.getAttribute("href");

    if (href && ["#", "javascript:void(0);"].indexOf(href) === -1) {
      a.setAttribute(
        "href",
        URI(href)
          .addSearch("token", token)
          .readable()
      );
    }
  });
};

/**
 * Add token for URL of link
 * 
 * @param [object] 
 */
export const setToken = ({ token, url }) => {
  return URI(url)
    .addSearch("token", token)
    .readable();
};

/** Check token
 *
 * @param [object]
 * @return [Promise]
 */
export const checkToken = ({ request_url, token, primary_membership }) => {
  return axios.post(
    request_url,
    { action: "token", uid: window.uid, data: { token, primary_membership, referral: (window.Rewardful ? Rewardful.referral : false) } },
    { responseType: "json", headers: { "Content-Type": "multipart/form-data" } }
  );
};
