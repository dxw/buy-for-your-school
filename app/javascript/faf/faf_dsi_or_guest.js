/*
  Change where the form submits
  1. DSI login page (continue as a registered user)
  2. internal page (continue as a guest)
*/

function changeFormAction(path) {
  const form = document.getElementsByTagName("form")[0];
  form.action = path;
}

window.addEventListener("load", () => {
  const dsiRadioButton = document.querySelectorAll("input[value=true]")[0];
  const guestRadioButton = document.querySelectorAll("input[value=false]")[0];

  dsiRadioButton.addEventListener("change", () => {
    if (dsiRadioButton.checked) {
      changeFormAction("/auth/dfe");
    }
  });

  guestRadioButton.addEventListener("change", () => {
    if (guestRadioButton.checked) {
      changeFormAction("/procurement-support");
    }
  });
});
