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

    // Funkció a dropdown listák feltöltésére API-ból
    async function populateDropdowns() {
        const dropdownsToFetch = {
            'court_name': 'birosag',
            'council_name': 'tanacs',
            'room_number': 'room',
            'resztvevok': 'resztvevok'
        };

        for (const [selectId, category] of Object.entries(dropdownsToFetch)) {
            const selectElement = document.getElementById(selectId);
            if (!selectElement) {
                console.warn(`populateDropdowns: A(z) ${selectId} select elem nem található a DOM-ban.`);
                continue;
            }

            // Töröljük a meglévő opciókat, kivéve az elsőt ("Válasszon...")
            while (selectElement.options.length > 1) { 
                selectElement.remove(1); 
            }

            try {
                const response = await fetch(`app/get_dropdown_items.php?category=${category}`);
                if (!response.ok) throw new Error(`Hiba az adatok lekérdezésekor a(z) ${category} kategóriához.`);
                const data = await response.json();

                if (data.success && Array.isArray(data.data)) {
                    data.data.forEach(item => {
                        const option = document.createElement('option');
                        option.value = item;
                        option.textContent = item;
                        selectElement.appendChild(option);
                    });
                } else {
                    console.error(`populateDropdowns: Hiba a(z) ${category} dropdown adatok betöltésekor:`, data.message || 'Ismeretlen hiba');
                }
            } catch (error) {
                console.error(`populateDropdowns: Hiba a(z) ${category} dropdown betöltésekor:`, error);
            }
        }
    }

    // Funkció a kereső inicializálására és a DOM átrendezésére
    function initSearch() {
        const searchInput = document.getElementById('Search'); // Az ID megmarad a list.php-ból
        const entryCardsContainer = document.getElementById('ListContainer'); // A kártyák konténere

        if (!searchInput) {
            console.warn('initSearch: A kereső input (#Search) nem található.');
            return;
        }
        if (!entryCardsContainer) {
            console.warn('initSearch: A bejegyzés kártyák konténere (#ListContainer) nem található.');
            return;
        }

        // Eseményfigyelő a keresőmező bemenetére
        searchInput.addEventListener('input', function() {
            const searchTerm = searchInput.value.toLowerCase();

            // KULCSFONTOSSÁGÚ VÁLTOZTATÁS: A szülő oszlop div-eket gyűjtjük be
            const allEntryColumns = Array.from(entryCardsContainer.querySelectorAll('.col-12.col-md-6.mb-4'));
            const matchingColumns = [];
            const nonMatchingColumns = [];

            allEntryColumns.forEach(columnDiv => {
                const card = columnDiv.querySelector('.entry-card'); // Megkeressük a kártyát az oszlopon belül
                if (!card) return; // Ha nincs kártya az oszlopban, kihagyjuk

                const cardText = card.textContent.toLowerCase();
                if (cardText.includes(searchTerm)) {
                    matchingColumns.push(columnDiv);
                    columnDiv.style.display = ''; // Megjelenítjük a teljes oszlopot
                } else {
                    nonMatchingColumns.push(columnDiv);
                    columnDiv.style.display = 'none'; // Elrejtjük a teljes oszlopot
                }
            });

            // DOM átrendezése: Először a találatok, majd a nem találatok (rejtve)
            const fragment = document.createDocumentFragment();

            // Hozzáadjuk a találatokat a fragmenthez
            matchingColumns.forEach(columnDiv => {
                fragment.appendChild(columnDiv);
            });

            // Hozzáadjuk a nem találatokat a fragmenthez (ezek rejtve maradnak)
            nonMatchingColumns.forEach(columnDiv => {
                fragment.appendChild(columnDiv);
            });

            // Töröljük a konténer összes gyermekét, majd hozzáadjuk a fragmentet
            while (entryCardsContainer.firstChild) {
                entryCardsContainer.removeChild(entryCardsContainer.firstChild);
            }
            entryCardsContainer.appendChild(fragment);

        });
    }

    // Funkció az oldalbetöltés kezelésére
    // Hozzáadva a 'params' objektumot a rugalmasabb paraméterkezeléshez
    function loadPage(page, dataId = null, params = {}) { 
        let url = page;
        const urlParams = new URLSearchParams();

        // Kezeljük az 'id' paramétert, ha van
        if (dataId !== null) {
            urlParams.append('id', dataId);
        }

        // Kezeljük az 'orderBy' paramétert, ha list.php-ról van szó
        if (page === 'list.php') {
            // Prioritize params.orderBy, then current select value, then default 'date'
            const currentSortBy = params.orderBy || document.getElementById('sortOrderSelect')?.value || 'date';
            urlParams.append('orderBy', currentSortBy);
        }

        // Build the query string
        const queryString = urlParams.toString();
        if (queryString) {
            url += (url.includes('?') ? '&' : '?') + queryString;
        }

        // KULCSFONTOSSÁGÚ VÁLTOZTATÁS: Cache-busting paraméter hozzáadása
        // Ez biztosítja, hogy a böngésző ne a gyorsítótárból szolgálja ki a kérést
        url += (url.includes('?') ? '&' : '?') + `_t=${new Date().getTime()}`;
        
        fetch(url)
            .then(response => {
                if (!response.ok) throw new Error('Hiba a betöltés során');
                return response.text();
            })
            .then(html => {
                contentArea.innerHTML = html;

                // Ha a list.php-t töltöttük be, akkor inicializáljuk a keresőt
                if (page === 'list.php') {
                    initSearch();
                    // Beállítjuk a legördülő menü kiválasztott értékét az URL paraméter alapján
                    const currentUrlParams = new URLSearchParams(window.location.search);
                    const orderByParam = currentUrlParams.get('orderBy');
                    if (orderByParam) {
                        setSelectedOption(document.getElementById('sortOrderSelect'), orderByParam);
                    }
                } 
                // Ha settings.php-t töltünk be, akkor hívjuk meg a reloadAllLists() függvényt
                else if (page === 'settings.php' && typeof reloadAllLists === 'function') {
                    reloadAllLists();
                }
                // Ha a rogzites.php-t töltöttük be (akár rögzítésre, akár szerkesztésre),
                // akkor hívjuk meg a loadEditData függvényt, ha van ID
                else if (page === 'rogzites.php') {
                    // Először feltöltjük a dropdown listákat
                    populateDropdowns().then(() => {
                        // Az adatfeltöltés csak akkor történik meg, ha van dataId.
                        // Ezt a then() blokkba tesszük, hogy a dropdownok már feltöltődjenek,
                        // mielőtt megpróbáljuk kiválasztani az értékeket.
                        if (dataId !== null) {
                            loadEditData(dataId);
                        } else {
                            // Ha új rögzítés, akkor is be kell állítani az eseményfigyelőt
                            // a jegyzekForm űrlapra
                            const jegyzekForm = document.getElementById('jegyzekForm');
                            if (jegyzekForm) {
                                jegyzekForm.addEventListener('submit', handleNewEntrySubmit); // Új függvény az új bejegyzés rögzítéséhez
                            }
                            // Reseteljük az űrlapot új rögzítés esetén
                            jegyzekForm.reset();
                            // Visszaállítjuk a címet és gombot eredeti állapotba
                            const formTitle = contentArea.querySelector('h2');
                            if (formTitle) {
                                formTitle.textContent = 'Új Tárgyalási Bejegyzés Rögzítése'; // Cím módosítva
                            }
                            const submitBtn = document.getElementById('jegyzekFormSubmitBtn');
                            if (submitBtn) {
                                submitBtn.innerHTML = 'Rögzítés és Mentés';
                                submitBtn.classList.remove('btn-primary');
                                submitBtn.classList.add('btn-success');
                            }
                            // Rejtett ID mező törlése
                            document.getElementById('recordId').value = '';

                            // ÚJ: Eseményfigyelő a "Mégse" gombra az új rögzítés módban is
                            const cancelBtn = document.getElementById('cancelEditBtn');
                            if (cancelBtn) {
                                cancelBtn.addEventListener('click', function() {
                                    loadPage('list.php'); // Vissza a listanézetre
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

    // Funkció a szerkesztő űrlap adatainak betöltésére és kezelésére
    // Ezt a függvényt hívja meg a kattintás eseményfigyelő
    function loadEditData(id) {
        fetch(`app/edit_entry_api.php?id=${id}`)
            .then(response => {
                if (!response.ok) throw new Error('Hiba az adatok lekérdezése során');
                return response.json();
            })
            .then(data => {
                if (data.success && data.data) {
                    const entryData = data.data; // Változó neve módosítva
                    
                    // Feltöltjük az űrlap mezőit az adatokkal
                    // Rejtett ID mező
                    document.getElementById('recordId').value = entryData.id || '';

                    // Select mezők feltöltése (MIUTÁN a populateDropdowns lefutott)
                    // Itt használjuk a setSelectedOption függvényt
                    setSelectedOption(document.getElementById('court_name'), entryData.birosag);
                    setSelectedOption(document.getElementById('council_name'), entryData.tanacs);
                    setSelectedOption(document.getElementById('room_number'), entryData.rooms);
                    setSelectedOption(document.getElementById('resztvevok'), entryData.resztvevok);

                    // Input/textarea mezők feltöltése
                    document.getElementById('date').value = entryData.date || '';
                    document.getElementById('sorszam').value = entryData.sorszam || ''; 
                    document.getElementById('ido').value = entryData.time ? entryData.time.substring(0, 5) : ''; // Idő formázása hh:mm-re
                    document.getElementById('ugyszam').value = entryData.ugyszam || '';
                    document.getElementById('letszam').value = entryData.letszam || '';
                    document.getElementById('ugyminoseg').value = entryData.ugyminoseg || '';
                    document.getElementById('intezkedes').value = entryData.intezkedes || '';

                    // Módosítjuk az űrlap címét és a gomb szövegét
                    const formTitle = contentArea.querySelector('h2');
                    if (formTitle) {
                        formTitle.textContent = 'Tárgyalási Bejegyzés Szerkesztése'; // Cím módosítva
                    }
                    const submitBtn = document.getElementById('jegyzekFormSubmitBtn');
                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fa-solid fa-save"></i> Módosítások mentése';
                        submitBtn.classList.remove('btn-success');
                        submitBtn.classList.add('btn-primary'); // Vagy tetszőleges szín
                    }

                    // Eseményfigyelő az űrlap beküldésére (szerkesztés)
                    const jegyzekForm = document.getElementById('jegyzekForm');
                    if (jegyzekForm) {
                        // Először eltávolítjuk a régi eseményfigyelőt, ha volt
                        jegyzekForm.removeEventListener('submit', handleNewEntrySubmit); 
                        jegyzekForm.addEventListener('submit', handleEditFormSubmit);
                    }

                    // Eseményfigyelő a "Mégse" gombra
                    const cancelBtn = document.getElementById('cancelEditBtn');
                    if (cancelBtn) {
                        cancelBtn.addEventListener('click', function() {
                            loadPage('list.php'); // Vissza a listanézetre
                        });
                    }

                } else {
                    showMessage('formMessage', data.message || 'Hiba az adatok betöltésekor.', 'danger');
                    loadPage('list.php'); // Hiba esetén visszatérünk a listanézetre
                }
            })
            .catch(error => {
                showMessage('formMessage', `Hiba az adatok lekérdezésekor: ${error.message}`, 'danger');
                loadPage('list.php'); // Hiba esetén visszatérünk a listanézetre
            });
    }

    // Funkció az ÚJ bejegyzés rögzítő űrlap AJAX-os beküldésének kezelésére
    function handleNewEntrySubmit(e) {
        e.preventDefault(); // Megakadályozzuk az alapértelmezett űrlap beküldést

        const form = e.target;
        const formData = new FormData(form);

        fetch('/app/process_entry.php', { 
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error('Hiba a rögzítés során');
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showMessage('formMessage', 'Sikeres rögzítés!', 'success'); 
                // Késleltetjük az oldalbetöltést, hogy az üzenet látható legyen
                setTimeout(() => {
                    loadPage('list.php'); 
                }, MESSAGE_DISPLAY_DURATION);
            } else {
                showMessage('formMessage', data.message || 'Hiba történt a rögzítéskor.', 'danger');
            }
        })
        .catch(error => {
            showMessage('formMessage', `Hiba a rögzítés során: ${error.message}`, 'danger');
        });
    }

    // Funkció a szerkesztő űrlap AJAX-os beküldésének kezelésére
    function handleEditFormSubmit(e) {
        e.preventDefault(); // Megakadályozzuk az alapértelmezett űrlap beküldést

        const form = e.target;
        const formData = new FormData(form);

        fetch('app/edit_entry_api.php', { // Ez az API a szerkesztéshez
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error('Hiba a mentés során');
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showMessage('formMessage', data.message, 'success');
                // Késleltetjük az oldalbetöltést, hogy az üzenet látható legyen
                setTimeout(() => {
                    loadPage('list.php'); 
                }, MESSAGE_DISPLAY_DURATION);
            } else {
                showMessage('formMessage', data.message || 'Hiba történt a mentéskor.', 'danger');
            }
        })
        .catch(error => {
            showMessage('formMessage', `Hiba a mentés során: ${error.message}`, 'danger');
        });
    }

    // Automatikusan betöltjük az alapértelmezett oldalt (list.php) az oldalbetöltéskor
    loadPage('list.php');

    // Kattintásra betöltjük a linkhez tartozó oldalt
    links.forEach(link => {
        link.addEventListener('click', function (e) {
            e.preventDefault();
            const page = this.getAttribute('data-page');
            
            // Ha a rogzites.php-t töltjük be, de nem szerkesztési módban,
            // akkor győződjünk meg róla, hogy az űrlap tiszta legyen
            if (page === 'rogzites.php') {
                loadPage(page, null); // Nincs ID, tehát új rögzítés
            } else {
                loadPage(page);
            }
        });
    });

    // Eseménydelegálás a contentArea-ra a dinamikusan betöltött elemekhez
    contentArea.addEventListener('click', function(e) {
        // Ellenőrizzük, hogy a kattintás egy "edit-button" osztályú elemen történt-e
        const closestButton = e.target.closest('.edit-button');
        const exportButton = e.target.closest('#exportCsvBtn'); // export gomb ellenőrzése

        if (closestButton) {
            e.preventDefault(); // Megakadályozzuk a link alapértelmezett viselkedését
            const id = closestButton.getAttribute('data-id');
            if (id) {
                loadPage('rogzites.php', id); // Meghívjuk a szerkesztő űrlap betöltését a rogzites.php-val
            } else {
                console.error('Hiányzó ID a szerkesztés gombhoz.');
            }
        } else if (exportButton) { // Ha az export gombra kattintottunk
            e.preventDefault(); // Megakadályozzuk az alapértelmezett viselkedést
            exportToCsv(); // Meghívjuk az export függvényt
        }
    });

    // Funkció az adatok CSV-be exportálásához
    async function exportToCsv() {
        try {
            // Lekérjük a kiválasztott rendezési szempontot
            const sortBy = document.getElementById('sortOrderSelect')?.value || 'date'; // Alapértelmezett: dátum
            const response = await fetch(`app/get_list_data.php?orderBy=room_number`);
            if (!response.ok) throw new Error('Hiba az adatok lekérdezésekor a CSV exportáláshoz.');
            const result = await response.json();

            if (result.success && Array.isArray(result.data)) {
                const data = result.data;
                if (data.length === 0) {
                    showMessage('formMessage', 'Nincs exportálható adat.', 'info'); // Használjuk a showMessage-t
                    return;
                }

                // CSV fejlécek (oszlopnevek)
                const headers = Object.keys(data[0]);
                const csvRows = [];
                // Hozzáadjuk a BOM-ot az UTF-8 kódoláshoz, hogy Excelben is jól jelenjen meg
                csvRows.push('\ufeff' + headers.join(';')); // BOM hozzáadása

                // Adatsorok hozzáadása
                data.forEach(row => {
                    const values = headers.map(header => {
                        let value = row[header] ?? '';
                        // Speciális karakterek kezelése CSV-ben (pl. vessző, idézőjel)
                        value = String(value).replace(/"/g, '""'); // Idézőjelek duplázása
                        if (value.includes(';') || value.includes('\n') || value.includes('"')) {
                            value = `"${value}"`; // Ha speciális karakter van, tegyük idézőjelbe
                        }
                        return value;
                    });
                    csvRows.push(values.join(';'));
                });

                // CSV string összeállítása
                const csvString = csvRows.join('\n');

                // CSV fájl letöltése
                const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
                const link = document.createElement('a');
                if (link.download !== undefined) { // Modern böngészők támogatása
                    const url = URL.createObjectURL(blob);
                    link.setAttribute('href', url);
                    link.setAttribute('download', 'bejegyzesek_' + new Date().toISOString().slice(0,10) + '.csv'); // Fájlnév módosítva
                    link.style.visibility = 'hidden';
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                } else {
                    showMessage('formMessage', 'A böngészője nem támogatja a fájlletöltést. Kérjük, másolja ki az adatokat manuálisan.', 'warning');
                }
                
                showMessage('formMessage', 'Adatok sikeresen exportálva CSV-be!', 'success'); // Használjuk a showMessage-t
            } else {
                showMessage('formMessage', result.message || 'Hiba történt az adatok lekérdezésekor a CSV exportáláshoz.', 'danger');
            }
        } catch (error) {
            showMessage('formMessage', `Hiba a CSV exportálás során: ${error.message}`, 'danger');
        }
    }
});
