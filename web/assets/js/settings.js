// This function is called by main.js when settings.php is loaded
function reloadAllLists() {
    console.log('reloadAllLists called');
    loadDropdown('birosag');
    loadDropdown('tanacs');
    loadDropdown('room');
    loadDropdown('resztvevok');
}

// // Load dropdown options
// async function loadDropdown(category) {
//     const selectElement = document.getElementById(`${category}-select`);
//     const messageDiv = document.getElementById(`${category}-message`);
    
//     console.log(`Loading dropdown for ${category}:`, selectElement ? 'Found' : 'Not found');
    
//     if (!selectElement) {
//         console.error(`Select element ${category}-select not found`);
//         return;
//     }

//     // Clear existing options (keep first placeholder)
//     selectElement.innerHTML = '<option value="">Válasszon...</option>';
//     if (messageDiv) messageDiv.classList.add('d-none');

//     // Use 'type' parameter to trigger dropdown mode
//     const url = `app/get_settings.php?type=${encodeURIComponent(category)}`;
//     console.log(`Fetching: ${url}`);

//     try {
//         const response = await fetch(url, { cache: 'no-store' });
//         const raw = await response.text();
//         console.log(`Response for ${category}:`, raw.substring(0, 200));

//         if (!response.ok) {
//             throw new Error(`HTTP ${response.status}: ${raw.slice(0, 200)}`);
//         }

//         let result;
//         try {
//             result = JSON.parse(raw);
//         } catch (e) {
//             console.error(`JSON parse error for ${category}:`, e);
//             throw new Error(`Érvénytelen JSON válasz: ${raw.slice(0, 200)}`);
//         }

//         console.log(`Parsed result for ${category}:`, result);

//         if (result.success && Array.isArray(result.data)) {
//             console.log(`Adding ${result.data.length} options to ${category}`);
//             result.data.forEach(item => {
//                 const option = document.createElement('option');
//                 option.value = item.id;
//                 option.textContent = item.value;
//                 option.dataset.value = item.value; // Store original value for editing
//                 selectElement.appendChild(option);
//             });
//         } else {
//             throw new Error(result.message || 'Helytelen adatformátum érkezett a szerverről.');
//         }
//     } catch (error) {
//         console.error(`loadDropdown: Hiba a(z) ${category} dropdown betöltésekor:`, error.message);
//         if (messageDiv) {
//             messageDiv.textContent = `Hiba: ${error.message}`;
//             messageDiv.classList.remove('d-none');
//             messageDiv.className = 'alert alert-danger';
//         }
//     }
// }


// Load dropdown options
async function loadDropdown(category) {
    const selectElement = document.getElementById(`${category}-select`);
    const messageDiv = document.getElementById(`${category}-message`);
    
    console.log(`Loading dropdown for ${category}:`, selectElement ? 'Found' : 'Not found');
    console.log(`Select element:`, selectElement);
    
    if (!selectElement) {
        console.error(`Select element ${category}-select not found`);
        return;
    }

    // Category-specific placeholders
    const placeholders = {
        'birosag': 'Válasszon bíróságot...',
        'tanacs': 'Válasszon tanácsot...',
        'room': 'Válasszon tárgyalót...',
        'resztvevok': 'Válasszon résztvevőt...'
    };
    const placeholder = placeholders[category] || 'Válasszon...';

    // Clear existing options (keep first placeholder)
    selectElement.innerHTML = `<option value="">${placeholder}</option>`;
    console.log(`Cleared ${category} dropdown, current options:`, selectElement.children.length);
    
    if (messageDiv) messageDiv.classList.add('d-none');

    const url = `app/get_settings.php?type=${encodeURIComponent(category)}`;
    console.log(`Fetching: ${url}`);

    try {
        const response = await fetch(url, { cache: 'no-store' });
        const raw = await response.text();
        console.log(`Response for ${category}:`, raw.substring(0, 200));

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${raw.slice(0, 200)}`);
        }

        let result;
        try {
            result = JSON.parse(raw);
        } catch (e) {
            console.error(`JSON parse error for ${category}:`, e);
            throw new Error(`Érvénytelen JSON válasz: ${raw.slice(0, 200)}`);
        }

        console.log(`Parsed result for ${category}:`, result);

        if (result.success && Array.isArray(result.data)) {
            console.log(`Adding ${result.data.length} options to ${category}`);
            
            // Sort alphabetically for all categories
            result.data.sort((a, b) => a.value.localeCompare(b.value, 'hu'));
            
            result.data.forEach((item, index) => {
                console.log(`Adding option ${index}:`, item);
                const option = document.createElement('option');
                option.value = item.id;
                option.textContent = item.value;
                option.dataset.value = item.value;
                selectElement.appendChild(option);
                console.log(`Added option, select now has ${selectElement.children.length} options`);
            });
            console.log(`Final ${category} dropdown:`, selectElement.innerHTML);
        } else {
            throw new Error(result.message || 'Helytelen adatformátum érkezett a szerverről.');
        }
    } catch (error) {
        console.error(`loadDropdown: Hiba a(z) ${category} dropdown betöltésekor:`, error.message);
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
        await loadDropdown(category); // Reload dropdown
        showMessage(category, 'Sikeresen hozzáadva!', 'success');
    } catch (e) {
        showMessage(category, `Hiba: ${e.message}`, 'danger');
    }
}

// Delete item
async function deleteItem(category) {
    const select = document.getElementById(`${category}-select`);
    if (!select || !select.value) {
        showMessage(category, 'Válasszon ki egy elemet a törléshez!', 'warning');
        return;
    }
    
    const selectedOption = select.options[select.selectedIndex];
    const itemName = selectedOption.textContent;
    
    if (!confirm(`Biztosan törölni szeretné ezt az elemet: ${itemName}?`)) return;
    
    try {
        const res = await fetch('app/removeItem.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: category, id: parseInt(select.value) })
        });
        const data = await res.json();
        if (!res.ok || !data.success) throw new Error(data.message || 'Hiba a törléskor.');
        await loadDropdown(category); // Reload dropdown
        showMessage(category, 'Sikeresen törölve!', 'success');
    } catch (e) {
        showMessage(category, `Hiba: ${e.message}`, 'danger');
    }
}

// Edit item
async function editItem(category) {
    const select = document.getElementById(`${category}-select`);
    if (!select || !select.value) {
        showMessage(category, 'Válasszon ki egy elemet a szerkesztéshez!', 'warning');
        return;
    }
    
    const selectedOption = select.options[select.selectedIndex];
    const oldValue = selectedOption.dataset.value || selectedOption.textContent;
    const newValue = prompt('Új érték:', oldValue);
    
    if (newValue === null) return; // cancelled
    const trimmed = newValue.trim();
    if (!trimmed || trimmed === oldValue) return;

    try {
        const res = await fetch('app/updateItem.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ type: category, id: parseInt(select.value), value: trimmed })
        });
        const data = await res.json();
        if (!res.ok || !data.success) throw new Error(data.message || 'Hiba a módosításkor.');
        await loadDropdown(category); // Reload dropdown
        showMessage(category, 'Sikeresen módosítva!', 'success');
    } catch (e) {
        showMessage(category, `Hiba: ${e.message}`, 'danger');
    }
}

// Show message
function showMessage(category, message, type) {
    const messageDiv = document.getElementById(`${category}-message`);
    if (messageDiv) {
        messageDiv.textContent = message;
        messageDiv.className = `alert alert-${type}`;
        messageDiv.classList.remove('d-none');
        setTimeout(() => messageDiv.classList.add('d-none'), 3000);
    }
}

// Event delegation for buttons
document.addEventListener('click', function (e) {
    const addBtn = e.target.closest('[data-add-category]');
    if (addBtn) {
        const category = addBtn.getAttribute('data-add-category');
        addItem(category);
        return;
    }
    
    const editBtn = e.target.closest('[data-edit-category]');
    if (editBtn) {
        const category = editBtn.getAttribute('data-edit-category');
        editItem(category);
        return;
    }
    
    const deleteBtn = e.target.closest('[data-delete-category]');
    if (deleteBtn) {
        const category = deleteBtn.getAttribute('data-delete-category');
        deleteItem(category);
    }
});