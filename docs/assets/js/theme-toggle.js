(function () {
  const storageKey = 'chatpharo-docs-theme';
  const toggle = document.getElementById('theme-toggle');
  if (!toggle) {
    return;
  }

  const prefersDarkQuery = window.matchMedia('(prefers-color-scheme: dark)');

  const getPreferredTheme = () => {
    try {
      const stored = localStorage.getItem(storageKey);
      if (stored === 'light' || stored === 'dark') {
        return stored;
      }
    } catch (error) {
      console.warn('Unable to access localStorage for theme preference.', error);
    }
    return prefersDarkQuery.matches ? 'dark' : 'light';
  };

  const setTheme = (theme) => {
    document.documentElement.dataset.theme = theme;
    const isDark = theme === 'dark';
    toggle.setAttribute('aria-pressed', String(isDark));
    toggle.textContent = isDark ? '☀️ Light theme' : '🌙 Dark theme';
  };

  setTheme(getPreferredTheme());

  toggle.addEventListener('click', () => {
    const nextTheme = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
    try {
      localStorage.setItem(storageKey, nextTheme);
    } catch (error) {
      console.warn('Unable to persist theme preference to localStorage.', error);
    }
    setTheme(nextTheme);
  });

  const handleSystemChange = (event) => {
    try {
      const stored = localStorage.getItem(storageKey);
      if (stored === 'light' || stored === 'dark') {
        return;
      }
    } catch (error) {
      // Ignore storage access issues and follow system preference.
    }
    setTheme(event.matches ? 'dark' : 'light');
  };

  if (typeof prefersDarkQuery.addEventListener === 'function') {
    prefersDarkQuery.addEventListener('change', handleSystemChange);
  } else if (typeof prefersDarkQuery.addListener === 'function') {
    prefersDarkQuery.addListener(handleSystemChange);
  }
})();