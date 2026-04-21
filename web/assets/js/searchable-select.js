// Searchable select: replaces <select> elements with a filterable combobox.
// Usage: SearchableSelect.init('select.form-select');

const SearchableSelect = (function () {

    // Shared body-level dropdown — repositioned per active input
    let activeDropdown = null;

    function positionDropdown(dropdown, input) {
        const rect = input.getBoundingClientRect();
        dropdown.style.left   = rect.left + window.scrollX + 'px';
        dropdown.style.top    = rect.bottom + window.scrollY + 'px';
        dropdown.style.width  = rect.width + 'px';
    }

    function build(select) {
        if (select.dataset.searchable) return;
        select.dataset.searchable = '1';

        const wrapper = document.createElement('div');
        wrapper.className = 'ss-wrapper';

        const input = document.createElement('input');
        input.type = 'text';
        input.className = select.className + ' ss-input';
        input.setAttribute('autocomplete', 'off');
        input.setAttribute('placeholder', select.options[0]?.text || 'Válasszon...');

        const dropdown = document.createElement('div');
        dropdown.className = 'ss-dropdown';
        // Attach to body so Bootstrap input-group overflow doesn't clip it
        dropdown._ssSelect = select;
        document.body.appendChild(dropdown);

        select.parentNode.insertBefore(wrapper, select);
        wrapper.appendChild(input);
        wrapper.appendChild(select);
        select.style.display = 'none';

        function getOptions() {
            return Array.from(select.options).filter(o => o.value !== '');
        }

        function normalize(str) {
            return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase();
        }

        function renderOptions(filter) {
            const term = normalize(filter || '');
            dropdown.innerHTML = '';
            const matched = getOptions().filter(o => normalize(o.text).includes(term));

            if (matched.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'ss-option ss-empty';
                empty.textContent = 'Nincs találat';
                dropdown.appendChild(empty);
                return;
            }

            matched.forEach(opt => {
                const item = document.createElement('div');
                item.className = 'ss-option' + (opt.value === select.value ? ' ss-selected' : '');
                item.textContent = opt.text;
                item.dataset.value = opt.value;
                item.addEventListener('mousedown', function (e) {
                    e.preventDefault();
                    select.value = opt.value;
                    input.value = opt.text;
                    closeDropdown();
                    select.dispatchEvent(new Event('change', { bubbles: true }));
                });
                dropdown.appendChild(item);
            });
        }

        function openDropdown() {
            // Close any other open dropdown first
            if (activeDropdown && activeDropdown !== dropdown) {
                activeDropdown.classList.remove('ss-open');
            }
            activeDropdown = dropdown;
            positionDropdown(dropdown, input);
            renderOptions(input.value);
            dropdown.classList.add('ss-open');
        }

        function closeDropdown() {
            dropdown.classList.remove('ss-open');
            if (activeDropdown === dropdown) activeDropdown = null;
        }

        function syncFromSelect() {
            const selected = select.options[select.selectedIndex];
            if (selected && selected.value) {
                input.value = selected.text;
            } else {
                input.value = '';
            }
        }

        input.addEventListener('focus', function () {
            input.value = '';
            openDropdown();
        });

        input.addEventListener('input', function () {
            openDropdown();
            if (input.value === '') {
                select.value = '';
            }
        });

        input.addEventListener('blur', function () {
            syncFromSelect();
            setTimeout(closeDropdown, 150);
        });

        // Reposition on scroll/resize
        window.addEventListener('scroll', function () {
            if (dropdown.classList.contains('ss-open')) {
                positionDropdown(dropdown, input);
            }
        }, { passive: true });

        select.addEventListener('change', syncFromSelect);

        syncFromSelect();
    }

    function rebuild(select) {
        // Remove existing wrapper so build() can re-apply cleanly
        if (select.dataset.searchable) {
            delete select.dataset.searchable;
            const wrapper = select.parentNode;
            if (wrapper && wrapper.classList.contains('ss-wrapper')) {
                wrapper.parentNode.insertBefore(select, wrapper);
                // Remove orphaned body dropdown tied to this select
                document.querySelectorAll('.ss-dropdown').forEach(d => {
                    if (d._ssSelect === select) d.remove();
                });
                wrapper.remove();
            }
            select.style.display = '';
        }
        build(select);
    }

    return {
        init: function (selector) {
            document.querySelectorAll(selector).forEach(build);
        },
        reinit: function (selectOrSelector) {
            if (typeof selectOrSelector === 'string') {
                document.querySelectorAll(selectOrSelector).forEach(rebuild);
            } else {
                rebuild(selectOrSelector);
            }
        }
    };
})();