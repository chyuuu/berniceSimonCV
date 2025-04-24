//backToTopPopup
const backToTopPopup = document.getElementById("backToTopPopup");

// window.onscroll = function () {
    window.addEventListener("scroll", function () {
        if (
            document.body.scrollTop > 150 ||
            document.documentElement.scrollTop > 150
        ) {
            backToTopPopup.style.display = "block";
        } else {
            backToTopPopup.style.display = "none";
        }
    }
);

// maybe add a feature where the popup can reappear if scrolled back to
setTimeout(function () {
    backToTopPopup.classList.add("fade-out");

    setTimeout(function () {
        backToTopPopup.style.display = "block";
    }, 4000);
}, 4000);