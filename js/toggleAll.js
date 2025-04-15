// showAll/hideAll button
const toggleAllBtn = document.getElementById("toggleAll");
const toggleIcon = document.getElementById("toggleIcon");
let areAllShown = false; // track state

toggleAllBtn.addEventListener("click", function () {
    const collapsibles = document.querySelectorAll('.code-collapse');
    collapsibles.forEach(function (el) {
        const bsCollapse = new bootstrap.Collapse(el, {
            toggle: false
        });
        if (areAllShown) {
            bsCollapse.hide();
        } else {
            bsCollapse.show();
        }
    });

    areAllShown = !areAllShown;
    toggleIcon.src = areAllShown ? "./images/closed_eye.png" : "./images/open_eye.png";
});