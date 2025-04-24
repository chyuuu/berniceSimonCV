const toggleAllPopup = document.getElementById("toggleAllPopup");

// window.onscroll = function () {
    window.addEventListener("scroll", function () {
    if (
        document.body.scrollTop > 20 ||
        document.documentElement.scrollTop > 20
    ) {
        toggleAllPopup.style.display = "none";
    } else {
        toggleAllPopup.style.display = "block";
    }
});