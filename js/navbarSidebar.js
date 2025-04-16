// loading navbar active tabs and load sidebar.html if present
(async function () {
    const navbarData = await fetch('navbar.html').then(res => res.text());
    document.getElementById('navbar').innerHTML = navbarData;

    const sidebarElement = document.getElementById('sidebar');
    if (sidebarElement) {
        try {
            const sidebarData = await fetch('sidebar.html').then(res => res.text());
            sidebarElement.innerHTML = sidebarData;
        } catch (err) {
            console.warn('Sidebar failed to load:', err);
        }
    }

    // highlight active nav
    const path = window.location.pathname;

    if (path.includes('index.html') || path === '/' || path === '/index') {
        document.getElementById('nav-home')?.classList.add('active');
    } else if (path.includes('about.html')) {
        document.getElementById('nav-about')?.classList.add('active');
    } else if (path.includes('projects.html')) {
        document.getElementById('nav-projects')?.classList.add('active');
    } else if (path.includes('resume.html')) {
        document.getElementById('nav-resume')?.classList.add('active');
    } else if (path.includes('testimonials.html')) {
        document.getElementById('nav-testimonials')?.classList.add('active');
    }
})();