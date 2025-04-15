// loading .projects.html code
document.addEventListener('DOMContentLoaded', () => {
    fetch('code-snippets/filter_latest_date.R')
      .then(res => res.text())
      .then(code => {
        document.getElementById('filterLatestDate').textContent = code;
        hljs.highlightElement(document.getElementById('filterLatestDate'));
      });
  
    fetch('code-snippets/icf_protocol_version_sorting.R')
      .then(res => res.text())
      .then(code => {
        document.getElementById('icfProtVerSorting').textContent = code;
        hljs.highlightElement(document.getElementById('icfProtVerSorting'));
      });
    
    fetch('code-snippets/file_splitting.py')
      .then(res => res.text())
      .then(code => {
        document.getElementById('fileSplitting').textContent = code;
        hljs.highlightElement(document.getElementById('fileSplitting'));
      });
  });