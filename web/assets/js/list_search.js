function initSearch() { 
    const searchInput = document.getElementById('Search');
    // ellenőrizzük, hogy az searchInput létezik-e, mielőtt használnánk
    if (!searchInput) {
        console.warn("Keresőmező (Search) nem található.");
        return; 
    }
    const listCards = document.querySelectorAll('.list-card');

    searchInput.addEventListener('keyup', function() {
        const searchTerm = searchInput.value.toLowerCase();

        listCards.forEach(card => {
            const parentCol = card.closest('.col-12.col-md-6'); 

            const ugyszamText = card.querySelector('.card-header').textContent.toLowerCase();

            const birosagDiv = Array.from(card.querySelectorAll('.card-body .col-12.mb-2')).find(div => div.textContent.includes('Bíróság:'));
            const birosagText = birosagDiv ? birosagDiv.textContent.toLowerCase() : '';

            const tanacsDiv = Array.from(card.querySelectorAll('.card-body .col-12.mb-2')).find(div => div.textContent.includes('Tanács:'));
            const tanacsText = tanacsDiv ? tanacsDiv.textContent.toLowerCase() : '';

            const searchableText = `${ugyszamText} ${birosagText} ${tanacsText}`;

            if (searchableText.includes(searchTerm)) {
                parentCol.style.display = '';
            } else {
                parentCol.style.display = 'none';
            }
        });
    });
}