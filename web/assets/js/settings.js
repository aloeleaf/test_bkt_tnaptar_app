// This function is called by main.js when settings.php is loaded
function reloadAllLists() {
    loadList('birosag');
    loadList('tanacs');
    loadList('room');
    loadList('resztvevok');
}


// Load list items for a given category
async function loadList(category) {
    const listContainer = document.getElementById(`${category}-list`);
    const messageDiv = document.getElementById(`${category}-message`);
    if (!listContainer) return;

    listContainer.innerHTML = '<li class="list-group-item">Betöltés...</li>';
    if (messageDiv) messageDiv.classList.add('d-none');

    const url = `app/get_settings.php?category=${encodeURIComponent(category)}`;

    try {
        const response = await fetch(url, { cache: 'no-store' });
        const raw = await response.text();

        if (!response.ok) throw new Error(`HTTP ${response.status}: ${raw.slice(0, 200)}`);

        let result;
        try {
            result = JSON.parse(raw);
        } catch {
            throw new Error(`Érvénytelen JSON válasz: ${raw.slice(0, 200)}`);
        }

        // Normalize items from various possible shapes
        const items =
            Array.isArray(result) ? result :
            Array.isArray(result?.data) ? result.data :
            Array.isArray(result?.data?.items) ? result.data.items :
            null;

        if (!items) {
            console.error('Váratlan szerver válasz:', result);
            throw new Error('Váratlan adatszerkezet (nincs lista).');
        }

        listContainer.innerHTML = '';
        if (items.length === 0) {
            listContainer.innerHTML = '<li class="list-group-item">Nincsenek elemek ebben a kategóriában.</li>';
            return;
        }

        items.forEach(item => {
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center';

            const span = document.createElement('span');
            span.textContent = item.value ?? String(item);

            const btnGroup = document.createElement('div');

            const editBtn = document.createElement('button');
            editBtn.className = 'btn btn-sm btn-outline-secondary me-2 edit-item-btn';
            editBtn.title = 'Szerkesztés';
            editBtn.dataset.id = item.id ?? '';
            editBtn.dataset.value = item.value ?? String(item);
            editBtn.dataset.category = category;
            editBtn.innerHTML = '<i class="fa-solid fa-pencil"></i>';

            const delBtn = document.createElement('button');
            delBtn.className = 'btn btn-sm btn-outline-danger delete-item-btn';
            delBtn.title = 'Törlés';
            delBtn.dataset.id = item.id ?? '';
            delBtn.dataset.category = category;
            delBtn.innerHTML = '<i class="fa-solid fa-trash"></i>';

            btnGroup.appendChild(editBtn);
            btnGroup.appendChild(delBtn);

            li.appendChild(span);
            li.appendChild(btnGroup);
            listContainer.appendChild(li);
        });
    } catch (error) {
        listContainer.innerHTML = `<li class="list-group-item text-danger">Hiba a lista betöltésekor: ${error.message}</li>`;
        if (messageDiv) {
            messageDiv.textContent = `Hiba: ${error.message}`;
            messageDiv.classList.remove('d-none');
            messageDiv.className = 'alert alert-danger';
        }
    }
}


// Add item
async function addItem(category) {
    const input = document.getElementById(`${category}-input`);
    if (!input) return;
    const value = input.value.trim();
    if (!value) return;

    try {
        const res = await fetch('app/addItem.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: category, name: value })
        });
        const data = await res.json();
        if (!res.ok || !data.success) throw new Error(data.message || 'Hiba a hozzáadáskor.');
        input.value = '';
        await loadList(category);
    } catch (e) {
        alert(`Hiba: ${e.message}`);
    }
}

// Delete item
async function deleteItem(category, id) {
    if (!confirm('Biztosan törölni szeretné ezt az elemet?')) return;
    try {
        const res = await fetch('app/removeItem.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: category, id })
        });
        const data = await res.json();
        if (!res.ok || !data.success) throw new Error(data.message || 'Hiba a törléskor.');
        await loadList(category);
    } catch (e) {
        alert(`Hiba: ${e.message}`);
    }
}

// Edit item (simple prompt-based)
async function editItem(category, id, oldValue) {
    const newValue = prompt('Új érték:', oldValue);
    if (newValue === null) return; // cancelled
    const trimmed = newValue.trim();
    if (!trimmed || trimmed === oldValue) return;

    try {
        const res = await fetch('app/updateItem.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: category, id, value: trimmed })
        });
        const data = await res.json();
        if (!res.ok || !data.success) throw new Error(data.message || 'Hiba a módosításkor.');
        await loadList(category);
    } catch (e) {
        alert(`Hiba: ${e.message}`);
    }
}

// Event delegation for edit/delete/add
document.addEventListener('click', function (e) {
    const editBtn = e.target.closest('.edit-item-btn');
    if (editBtn) {
        editItem(editBtn.dataset.category, editBtn.dataset.id, editBtn.dataset.value);
        return;
    }
    const delBtn = e.target.closest('.delete-item-btn');
    if (delBtn) {
        deleteItem(delBtn.dataset.category, delBtn.dataset.id);
        return;
    }
    const addBtn = e.target.closest('[data-add-category]');
    if (addBtn) {
        const category = addBtn.getAttribute('data-add-category');
        addItem(category);
    }
});