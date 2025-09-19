// assets/js/main.js

document.addEventListener('DOMContentLoaded', function () {
    const links = document.querySelectorAll('.load-page');
    const contentArea = document.getElementById('content-area'); // Ez a fő tartalomterület
    const MESSAGE_DISPLAY_DURATION = 3000; // 3 másodperc az üzenet megjelenítésére

    // Segédfüggvény az üzenetek megjelenítéséhez
    function showMessage(elementId, message, type) {
        const messageDiv = document.getElementById(elementId);
        if (messageDiv) {
            messageDiv.textContent = message;
            messageDiv.className = `alert alert-${type}`;
            messageDiv.classList.remove('d-none');
            // Az üzenet elrejtése a beállított idő után
            setTimeout(() => {
                messageDiv.classList.add('d-none');
            }, MESSAGE_DISPLAY_DURATION);
        }
    }

    // Segédfüggvény a select elem kiválasztott opciójának beállítására
    function setSelectedOption(selectElement, valueToSelect) {
        if (!selectElement || !valueToSelect) return;
        let found = false;
        for (let i = 0; i < selectElement.options.length; i++) {
            if (selectElement.options[i].value === valueToSelect) {
                selectElement.selectedIndex = i;
                found = true;

                // Kiváltunk egy 'change' eseményt, hogy a böngésző frissítse a vizuális megjelenítést
                const event = new Event('change');
                selectElement.dispatchEvent(event);

                break;
            }
        }
        if (!found) {
            console.warn(`setSelectedOption: Az érték ("${valueToSelect}") nem található a(z) ${selectElement.id} select elem opciói között.`);
        }
    }

    // Funkció a legördülő menük dinamikus feltöltésére
    async function populateDropdowns() {
        const dropdownsToFetch = {
            court_name: 'birosag',
            council_name: 'tanacs',
            room_number: 'room',
            resztvevok: 'resztvevok'
        };

        for (const [selectId, type] of Object.entries(dropdownsToFetch)) {
            const selectElement = document.getElementById(selectId);
            if (!selectElement) continue;

            // keep first "Válasszon..." option, clear the rest
            while (selectElement.options.length > 1) {
                selectElement.remove(1);
            }

            let raw = '';
            try {
                const response = await fetch(`app/getItems.php?type=${encodeURIComponent(type)}`, { cache: 'no-store' });
                raw = await response.text();

                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${raw}`);
                }

                const data = JSON.parse(raw);

                if (data.success && Array.isArray(data.data)) {
                    data.data.forEach(item => {
                        const option = document.createElement('option');
                        option.value = item.value;
                        option.textContent = item.value;
                        selectElement.appendChild(option);
                    });
                } else {
                    throw new Error(data.message || 'Helytelen JSON szerkezet.');
                }
            } catch (err) {
                console.error(`populateDropdowns: Hiba a(z) ${type} dropdown betöltésekor:`, err.message, raw);
            }
        }
    }

    // Funkció a szerkesztő űrlap dropdownjainak feltöltésére
    async function populateEditFormDropdowns() {
        const dropdownsToFetch = {
            editBirosag: 'birosag',
            editTanacs: 'tanacs',
            editRooms: 'room',
            editResztvevok: 'resztvevok'
        };

        console.log('populateEditFormDropdowns called with:', Object.keys(dropdownsToFetch)); // Debug

        for (const [selectId, type] of Object.entries(dropdownsToFetch)) {
            console.log(`Processing dropdown: ${selectId} -> ${type}`); // Debug

            const selectElement = document.getElementById(selectId);

            if (!selectElement) {
                console.error(`Element with ID '${selectId}' not found!`);
                continue;
            }

            console.log(`Found element ${selectId}:`, selectElement); // Debug

            if (selectElement.tagName !== 'SELECT') {
                console.error(`Element ${selectId} is not a SELECT element, it's ${selectElement.tagName}`);
                continue;
            }

            // Clear existing options except first
            while (selectElement.options.length > 1) {
                selectElement.remove(1);
            }

            try {
                console.log(`Fetching data for ${type}...`); // Debug
                const response = await fetch(`app/getItems.php?type=${encodeURIComponent(type)}`, { cache: 'no-store' });
                const data = await response.json();

                console.log(`Response for ${type}:`, data); // Debug

                if (data.success && Array.isArray(data.data)) {
                    data.data.forEach(item => {
                        const option = document.createElement('option');
                        option.value = item.value;
                        option.textContent = item.value;
                        selectElement.appendChild(option);
                    });
                    console.log(`Successfully populated ${selectId} with ${data.data.length} options`);
                } else {
                    console.error(`Invalid data for ${type}:`, data);
                }
            } catch (err) {
                console.error(`Error fetching ${type}:`, err);
            }
        }
    }

    // Funkció a kereső inicializálására és a DOM átrendezésére
    function initSearch() {
        const searchInput = document.getElementById('Search');
        const entryCardsContainer = document.getElementById('ListContainer');

        if (!searchInput || !entryCardsContainer) {
            console.warn('initSearch: A kereső input vagy a konténer nem található.');
            return;
        }

        searchInput.addEventListener('input', function () {
            const searchTerm = searchInput.value.toLowerCase();
            const allEntryColumns = Array.from(entryCardsContainer.querySelectorAll('.col-12.col-md-6.mb-4'));
            const matchingColumns = [];
            const nonMatchingColumns = [];

            allEntryColumns.forEach(columnDiv => {
                const card = columnDiv.querySelector('.entry-card');
                if (!card) return;

                const cardText = card.textContent.toLowerCase();
                if (cardText.includes(searchTerm)) {
                    matchingColumns.push(columnDiv);
                    columnDiv.style.display = '';
                } else {
                    nonMatchingColumns.push(columnDiv);
                    columnDiv.style.display = 'none';
                }
            });

            const fragment = document.createDocumentFragment();

            matchingColumns.forEach(columnDiv => {
                fragment.appendChild(columnDiv);
            });

            nonMatchingColumns.forEach(columnDiv => {
                fragment.appendChild(columnDiv);
            });

            while (entryCardsContainer.firstChild) {
                entryCardsContainer.removeChild(entryCardsContainer.firstChild);
            }
            entryCardsContainer.appendChild(fragment);
        });
    }

    // Funkció az oldalbetöltés kezelésére
    function loadPage(page, dataId = null, params = {}) {
        let url = page;
        const urlParams = new URLSearchParams();

        if (dataId !== null) {
            urlParams.append('id', dataId);
        }

        if (page === 'list.php') {
            const currentSortBy = params.orderBy || document.getElementById('sortOrderSelect')?.value || 'date';
            urlParams.append('orderBy', currentSortBy);
        }

        const queryString = urlParams.toString();
        if (queryString) {
            url += (url.includes('?') ? '&' : '?') + queryString;
        }

        url += (url.includes('?') ? '&' : '?') + `_t=${new Date().getTime()}`;

        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('Hiba a betöltés során');
                return response.text();
            })
            .then(html => {
                contentArea.innerHTML = html;

                if (page === 'list.php') {
                    initSearch();
                    const currentUrlParams = new URLSearchParams(window.location.search);
                    const orderByParam = currentUrlParams.get('orderBy');
                    if (orderByParam) {
                        setSelectedOption(document.getElementById('sortOrderSelect'), orderByParam);
                    }
                }
                else if (page === 'settings.php' && typeof reloadAllLists === 'function') {
                    reloadAllLists();
                }
                else if (page === 'rogzites.php') {
                    populateDropdowns().then(() => {
                        if (dataId !== null) {
                            loadEditData(dataId);
                        } else {
                            const jegyzekForm = document.getElementById('jegyzekForm');
                            if (jegyzekForm) {
                                jegyzekForm.addEventListener('submit', handleNewEntrySubmit);
                                jegyzekForm.reset();
                            }

                            const formTitle = contentArea.querySelector('h2');
                            if (formTitle) {
                                formTitle.textContent = 'Új tárgyalási naptár bejegyzés';
                            }
                            const submitBtn = document.getElementById('jegyzekFormSubmitBtn');
                            if (submitBtn) {
                                submitBtn.innerHTML = 'Rögzítés és Mentés';
                                submitBtn.classList.remove('btn-primary');
                                submitBtn.classList.add('btn-success');
                            }

                            const recordIdInput = document.getElementById('recordId');
                            if (recordIdInput) recordIdInput.value = '';

                            const cancelBtn = document.getElementById('cancelEditBtn');
                            if (cancelBtn) {
                                cancelBtn.addEventListener('click', function () {
                                    loadPage('list.php');
                                });
                            }
                        }
                    });
                }
            })
            .catch(error => {
                contentArea.innerHTML = `<div class="alert alert-danger">Hiba történt: ${error.message}</div>`;
            });
    }

    // Funkció a szerkesztő űrlap betöltésére
    async function loadEditForm(entryId) {
        try {
            console.log('Loading edit form for entry ID:', entryId); // Debug

            const response = await fetch('edit_entry_form.php');
            const html = await response.text();
            contentArea.innerHTML = html;

            // Check if the element exists after loading HTML
            const editResztvevokElement = document.getElementById('editResztvevok');
            console.log('editResztvevok element after HTML load:', editResztvevokElement);

            // Populate dropdowns first
            console.log('Starting populateEditFormDropdowns...');
            await populateEditFormDropdowns();
            console.log('Finished populateEditFormDropdowns');

            // Then load entry data
            await loadEditFormData(entryId);

            // Set up form submission
            const editForm = document.getElementById('editEntryForm');
            if (editForm) {
                editForm.addEventListener('submit', handleEditFormSubmit);
            }

            // Set up cancel button
            const cancelBtn = document.getElementById('cancelEditBtn');
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function () {
                    loadPage('list.php');
                });
            }

        } catch (error) {
            console.error('Error loading edit form:', error);
            showMessage('editMessage', 'Hiba a szerkesztő form betöltésekor: ' + error.message, 'danger');
        }
    }


    // Funkció a szerkesztő űrlap adatainak betöltésére
async function loadEditFormData(entryId) {
    try {
        const response = await fetch(`app/get_list_data.php`);
        const result = await response.json();

        if (result.success) {
            const entry = result.data.find(item => item.id == entryId);
            if (entry) {
                console.log('Entry data:', entry); // Debug log
                console.log('Entry persons value:', entry.persons); // This is the correct field!

                // Populate form fields
                document.getElementById('editEntryId').value = entry.id;

                // Set dropdown values - USE entry.persons (not entry.resztvevok)
                setSelectedOption(document.getElementById('editBirosag'), entry.court_name);
                setSelectedOption(document.getElementById('editTanacs'), entry.council_name);
                setSelectedOption(document.getElementById('editRooms'), entry.room_number);
                setSelectedOption(document.getElementById('editResztvevok'), entry.persons); // Fixed!

                // Set other field values
                document.getElementById('editDate').value = entry.session_date || '';
                document.getElementById('editStartTime').value = entry.ido || '';
                document.getElementById('editEndTime').value = entry.befejez_ido || '';
                document.getElementById('editUgyszam').value = entry.ugyszam || '';
                document.getElementById('editAlperesTerhelt').value = entry.alperes_terhelt || '';
                document.getElementById('editFelperesVadlo').value = entry.felperes_vadlo || '';
                document.getElementById('editLetszam').value = entry.azon || '';
                document.getElementById('editSubject').value = (entry.ugyminoseg || '') + '\n' + (entry.intezkedes || '');
            } else {
                throw new Error('Bejegyzés nem található');
            }
        } else {
            throw new Error(result.message || 'Hiba az adatok betöltésekor');
        }
    } catch (error) {
        console.error('Error loading entry data:', error);
        showMessage('editMessage', 'Hiba az adatok betöltésekor: ' + error.message, 'danger');
    }
}

    // Funkció a szerkesztő űrlap adatainak betöltésére és kezelésére (legacy - rogzites.php-hoz)
    function loadEditData(id) {
        fetch(`app/edit_entry_api.php?id=${id}`)
            .then(response => {
                if (!response.ok) throw new Error('Hiba az adatok lekérdezése során');
                return response.json();
            })
            .then(data => {
                if (data.success && data.data) {
                    const entryData = data.data;

                    document.getElementById('recordId').value = entryData.id || '';

                    setSelectedOption(document.getElementById('court_name'), entryData.birosag);
                    setSelectedOption(document.getElementById('council_name'), entryData.tanacs);
                    setSelectedOption(document.getElementById('room_number'), entryData.rooms);
                    setSelectedOption(document.getElementById('resztvevok'), entryData.resztvevok);

                    document.getElementById('date').value = entryData.date || '';
                    document.getElementById('ido').value = entryData.start_time ? entryData.start_time.substring(0, 5) : '';
                    document.getElementById('ugyszam').value = entryData.ugyszam || '';
                    document.getElementById('letszam').value = entryData.letszam || '';
                    document.getElementById('ugyminoseg').value = entryData.ugyminoseg || '';
                    document.getElementById('intezkedes').value = entryData.intezkedes || '';

                    const formTitle = contentArea.querySelector('h2');
                    if (formTitle) {
                        formTitle.textContent = 'Tárgyalási Bejegyzés Szerkesztése';
                    }
                    const submitBtn = document.getElementById('jegyzekFormSubmitBtn');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fa-solid fa-save"></i> Módosítások mentése';
                        submitBtn.classList.remove('btn-success');
                        submitBtn.classList.add('btn-primary');
                    }

                    const jegyzekForm = document.getElementById('jegyzekForm');
                    if (jegyzekForm) {
                        jegyzekForm.removeEventListener('submit', handleNewEntrySubmit);
                        jegyzekForm.addEventListener('submit', handleEditFormSubmit);
                    }

                    const cancelBtn = document.getElementById('cancelEditBtn');
                    if (cancelBtn) {
                        cancelBtn.addEventListener('click', function () {
                            loadPage('list.php');
                        });
                    }

                } else {
                    showMessage('formMessage', data.message || 'Hiba az adatok betöltésekor.', 'danger');
                    loadPage('list.php');
                }
            })
            .catch(error => {
                showMessage('formMessage', `Hiba az adatok lekérdezésekor: ${error.message}`, 'danger');
                loadPage('list.php');
            });
    }

    // Új függvény az új bejegyzés rögzítésének kezelésére
    function handleNewEntrySubmit(e) {
        e.preventDefault();
        const form = e.target;
        const formData = new FormData(form);

        fetch('app/process_entry.php', {
            method: 'POST',
            body: formData,
            cache: 'no-store'
        })
            .then(async (response) => {
                const raw = await response.text();
                let data;
                try {
                    data = JSON.parse(raw);
                } catch {
                    console.error('Raw response from app/process_entry.php:', raw);
                    throw new Error('A szerver nem érvényes JSON-t küldött vissza.');
                }
                if (!response.ok || !data.success) {
                    const msg = data?.message || `Hiba (${response.status})`;
                    throw new Error(msg);
                }
                showMessage('formMessage', data.message || 'Sikeres rögzítés!', 'success');
                setTimeout(() => loadPage('list.php'), MESSAGE_DISPLAY_DURATION);
            })
            .catch(error => {
                showMessage('formMessage', `Hiba a rögzítés során: ${error.message}`, 'danger');
            });
    }

    // Funkció a szerkesztő űrlap AJAX-os beküldésének kezelésére
    function handleEditFormSubmit(e) {
        e.preventDefault();

        const form = e.target;
        const formData = new FormData(form);

        // Determine which endpoint to use based on form ID
        const endpoint = form.id === 'editEntryForm' ? 'app/update_entry.php' : 'app/edit_entry_api.php';
        const messageElement = form.id === 'editEntryForm' ? 'editMessage' : 'formMessage';

        fetch(endpoint, {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (!response.ok) throw new Error('Hiba a mentés során');
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    showMessage(messageElement, data.message, 'success');
                    setTimeout(() => {
                        loadPage('list.php');
                    }, MESSAGE_DISPLAY_DURATION);
                } else {
                    showMessage(messageElement, data.message || 'Hiba történt a mentéskor.', 'danger');
                }
            })
            .catch(error => {
                showMessage(messageElement, `Hiba a mentés során: ${error.message}`, 'danger');
            });
    }

    // Automatikusan betöltjük az alapértelmezett oldalt (list.php) az oldalbetöltéskor
    loadPage('list.php');

    // Kattintásra betöltjük a linkhez tartozó oldalt
    links.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const page = this.getAttribute('data-page');

            if (page === 'rogzites.php') {
                loadPage(page, null);
            } else {
                loadPage(page);
            }
        });
    });

    // Eseménydelegálás a contentArea-ra a dinamikusan betöltött elemekhez
    contentArea.addEventListener('click', function (e) {
        const closestButton = e.target.closest('.edit-button');
        const exportButton = e.target.closest('#exportCsvBtn');

        if (closestButton) {
            e.preventDefault();
            const id = closestButton.getAttribute('data-id');
            if (id) {
                // Use the new edit form instead of rogzites.php
                loadEditForm(id);
            } else {
                console.error('Hiányzó ID a szerkesztés gombhoz.');
            }
        } else if (exportButton) {
            e.preventDefault();
            exportToCsv();
        }
    });

    // Funkció az adatok CSV-be exportálásához
    async function exportToCsv() {
        try {
            const response = await fetch(`app/get_list_data.php?orderBy=room_number`);
            if (!response.ok) throw new Error('Hiba az adatok lekérdezésekor a CSV exportáláshoz.');
            const result = await response.json();

            if (result.success && Array.isArray(result.data)) {
                const data = result.data;
                if (data.length === 0) {
                    showMessage('formMessage', 'Nincs exportálható adat.', 'info');
                    return;
                }

                const headers = Object.keys(data[0]);
                const csvRows = [];
                csvRows.push('\ufeff' + headers.join(';'));

                data.forEach(row => {
                    const values = headers.map(header => {
                        let value = row[header] ?? '';
                        value = String(value).replace(/"/g, '""');
                        if (value.includes(';') || value.includes('\n') || value.includes('"')) {
                            value = `"${value}"`;
                        }
                        return value;
                    });
                    csvRows.push(values.join(';'));
                });

                const csvString = csvRows.join('\n');
                const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
                const link = document.createElement('a');
                if (link.download !== undefined) {
                    const url = URL.createObjectURL(blob);
                    link.setAttribute('href', url);
                    link.setAttribute('download', 'bejegyzesek_' + new Date().toISOString().slice(0, 10) + '.csv');
                    link.style.visibility = 'hidden';
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                } else {
                    showMessage('formMessage', 'A böngészője nem támogatja a fájlletöltést.', 'warning');
                }

                showMessage('formMessage', 'Adatok sikeresen exportálva CSV-be!', 'success');
            } else {
                showMessage('formMessage', result.message || 'Hiba történt az adatok lekérdezésekor a CSV exportáláshoz.', 'danger');
            }
        } catch (error) {
            showMessage('formMessage', `Hiba a CSV exportálás során: ${error.message}`, 'danger');
        }
    }
});