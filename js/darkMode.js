// dark theme button
const toggle = document.getElementById("theme-toggle");
const html = document.documentElement; // the <html> element

// Apply any saved preference when the page loads
const saved = localStorage.getItem("theme") || "light";
html.setAttribute("data-bs-theme", saved);

toggle.addEventListener("click", () => {
  const current = html.getAttribute("data-bs-theme");
  const next = current === "dark" ? "light" : "dark";
  html.setAttribute("data-bs-theme", next);
  localStorage.setItem("theme", next); // remember the choice
});
