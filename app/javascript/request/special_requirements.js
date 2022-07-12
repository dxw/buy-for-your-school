/*
  Manage the special requirements fields in the support/FaF request form
*/

import { getFormId, getFormIdUnderscore } from "./common.js";

window.addEventListener("load", () => {
  const formId = getFormId();
  const formIdUnderscore = getFormIdUnderscore();

  const specialRequirementsChoiceNoRadioButton = document.getElementById(`${formId}-special-requirements-choice-no-field`);
  const specialRequirementsInput = document.getElementsByName(`${formIdUnderscore}[special_requirements]`)[0];

  specialRequirementsChoiceNoRadioButton.addEventListener("change", () => {
    if (specialRequirementsChoiceNoRadioButton.checked) {
      specialRequirementsInput.value = null;
    }
  });
});
