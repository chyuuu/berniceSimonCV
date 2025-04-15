const backToTopBtn = document.getElementById("backToTop");

window.onscroll = function () {
    if (
        document.body.scrollTop > 150 ||
        document.documentElement.scrollTop > 150
    ) {
        backToTopBtn.style.display = "block";
    } else {
        backToTopBtn.style.display = "none";
    }
}

backToTopBtn.addEventListener("click", function () {
    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });
});

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

(async function () {
    const navbarData = await fetch('navbar.html').then(res => res.text());
    // const sidebarData = await fetch('sidebar.html').then(res => res.text());

    document.getElementById('navbar').innerHTML = navbarData;
    // document.getElementById('sidebar').innerHTML = sidebarData;

    // add the 'active' class after the navbar is loaded
    const path = window.location.pathname;

    if (path.includes('index.html') || path === '/' || path === '/index') {
        document.getElementById('nav-home')?.classList.add('active');
    } else if (path.includes('about.html')) {
        document.getElementById('nav-about')?.classList.add('active');
    } else if (path.includes('projects.html')) {
        document.getElementById('nav-projects')?.classList.add('active');
    } else if (path.includes('resume.html')) {
        document.getElementById('nav-resume')?.classList.add('active');
    }
})();