(function () {
  const layoutReady = () => {
    const toc = document.getElementById('toc');
    const toggleButton = document.getElementById('toc-toggle');
    const toggleContainer = toggleButton ? toggleButton.closest('.toc-toggle-container') : null;
    const list = toc ? toc.querySelector('.toc__list') : null;
    const main = document.querySelector('main');
    if (!toc || !toggleButton || !list || !main) {
      return;
    }

    const headings = Array.from(main.querySelectorAll('h2, h3'));
    if (!headings.length) {
      toc.setAttribute('hidden', '');
      toggleButton.setAttribute('hidden', '');
      if (toggleContainer) {
        toggleContainer.setAttribute('hidden', '');
      }
      return;
    }

    const slugCounts = new Map();
    const slugify = (text) => {
      const baseSlug = text
        .toLowerCase()
        .trim()
        .replace(/[^a-z0-9\s-]/g, '')
        .replace(/\s+/g, '-')
        .replace(/-+/g, '-');
      const safeSlug = baseSlug || 'section';
      const count = slugCounts.get(safeSlug) || 0;
      slugCounts.set(safeSlug, count + 1);
      return count ? `${safeSlug}-${count + 1}` : safeSlug;
    };

    headings.forEach((heading) => {
      if (!heading.id) {
        heading.id = slugify(heading.textContent || heading.innerText || 'section');
      }

      const listItem = document.createElement('li');
      listItem.classList.add('toc__item', `toc__item--level-${heading.tagName.toLowerCase()}`);

      const link = document.createElement('a');
      link.className = 'toc__link';
      link.href = `#${heading.id}`;
      link.textContent = heading.textContent || heading.innerText || heading.id;

      listItem.appendChild(link);
      list.appendChild(listItem);
    });

    const collapse = () => {
      toc.classList.add('toc--collapsed');
      toggleButton.setAttribute('aria-expanded', 'false');
      toggleButton.textContent = 'Show table of contents';
    };

    const expand = () => {
      toc.classList.remove('toc--collapsed');
      toggleButton.setAttribute('aria-expanded', 'true');
      toggleButton.textContent = 'Hide table of contents';
    };

    toggleButton.addEventListener('click', () => {
      if (toc.classList.contains('toc--collapsed')) {
        expand();
      } else {
        collapse();
      }
    });

    if (window.matchMedia('(max-width: 900px)').matches) {
      collapse();
    } else {
      expand();
    }
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', layoutReady);
  } else {
    layoutReady();
  }
})();
