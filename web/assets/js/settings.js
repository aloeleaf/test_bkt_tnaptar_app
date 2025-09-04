function addItem(type) {
    const input = document.getElementById(type + 'Input');
    const name = input.value.trim();
    if (!name) return;

    fetch('/app/addItem.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, type })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            input.value = '';
            reloadAllLists();
        }
    });
}

function deleteItem(id, type) {
    fetch('/app/removeItem.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ id, type })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            reloadAllLists();
        }
    });
}

function loadList(type) {
    fetch(`/app/getItems.php?type=${type}`)
        .then(res => res.json())
        .then(data => {
            const list = document.getElementById(type + 'List');
            list.innerHTML = '';
            data.forEach(item => {
                const li = document.createElement('li');
                li.classList.add('list-group-item', 'd-flex', 'justify-content-between', 'align-items-center'); 
                
                const textSpan = document.createElement('span'); // külön span a szövegnek
                textSpan.textContent = item.value;
                li.appendChild(textSpan); // A span hozzáadása a li-hez

                const btn = document.createElement('button');
                btn.classList.add('btn', 'btn-danger', 'btn-sm'); // Bootstrap gomb stílus (piros, kicsi)
                btn.title = 'Törlés'; // tooltip         
                const icon = document.createElement('i'); // ikon létrehozása
                icon.classList.add('fa-solid', 'fa-trash'); // Font Awesome ikon
                btn.appendChild(icon);
                btn.onclick = () => deleteItem(item.id, type);
                li.appendChild(btn);
                list.appendChild(li);
            });
        });
}

function reloadAllLists() {
    ['birosag', 'tanacs', 'room', 'resztvevok'].forEach(type => loadList(type));
};