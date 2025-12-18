# Tárgyalási Naptár Alkalmazás (BKT Naptár App)

## Projekt áttekintés
Ez egy Docker alapú webalkalmazás tárgyalási időpontok kezelésére, Active Directory LDAP autentikációval, PostgreSQL adatbázissal és szerepkör-alapú hozzáférés-szabályozással (RBAC).

---

## Könyvtárszerkezet és fájlok funkciói

### 📁 Gyökér könyvtár
```
/srv/containers/test_bkt_tnaptar_app/
```

| Fájl/Mappa | Funkció |
|------------|---------|
| `README.md` | Projekt dokumentáció (ez a fájl) |
| `info.md` | Részletes projekt struktúra áttekintés |
| `.env` | Környezeti változók (adatbázis, LDAP beállítások) |
| `.gitignore` | Git verziókezelés kizárási szabályok |
| `test_bkt_tnaptar_app.code-workspace` | VS Code workspace konfiguráció |

---

### 📁 `web/` - Webalkalmazás fő könyvtára

#### Főbb PHP oldalak:
| Fájl | Funkció |
|------|---------|
| `index.php` | Bejelentkezési oldal (LDAP autentikáció) |
| `dashboard.php` | Felhasználói irányítópult (session kezelés, 30 perces timeout) |
| `list.php` | Tárgyalási időpontok listázása (szűrhető, rendezhető) |
| `rogzites.php` | Új tárgyalási időpont rögzítése |
| `edit_entry_form.php` | Tárgyalási időpont szerkesztése |
| `delete_entry.php` | Tárgyalási időpont törlése (Admin jogosultság szükséges) |
| `room_bookings.php` | Adott tárgyaló foglalásainak megjelenítése |
| `room_matrix.php` | Tárgyaló mátrix nézet (HTML kimenet a `foglalas_matrix_view` nézetből) |
| `settings.php` | Adminisztrációs felület (bíróságok, tanácsok, termek kezelése) |
| `logout.php` | Kijelentkezés (session törlés) |

---

### 📁 `web/app/` - Backend API és osztályok

| Fájl | Funkció |
|------|---------|
| **`Auth.php`** | **Autentikációs osztály** - LDAP bejelentkezés, RBAC, session kezelés, rate limiting |
| **`Database.php`** | **Adatbázis kapcsolat osztály** - PostgreSQL PDO kapcsolat |
| `addItem.php` | Új elem hozzáadása (bíróság, tanács, terem) |
| `updateItem.php` | Elem frissítése |
| `removeItem.php` | Elem törlése |
| `getItems.php` | Elemek lekérdezése (dropdown listák populálásához) |
| `get_list_data.php` | Tárgyalási lista adatok lekérdezése (AJAX) |
| `get_settings.php` | Adminisztrációs beállítások lekérdezése |
| `process_entry.php` | Tárgyalási bejegyzés feldolgozása (létrehozás/frissítés) |
| `edit_entry_api.php` | Tárgyalási bejegyzés módosítás API endpoint |
| `update_entry.php` | Tárgyalási bejegyzés frissítése |

#### `Auth.php` részletes funkciói:
- LDAP autentikáció Active Directory ellen (birosagiad.hu domain)
- Felhasználói adatok tárolása PostgreSQL-ben (`name` tábla - UPSERT mechanizmus)
- Dinamikus szerepkör-meghatározás AD csoporttagság alapján:
  - **Betekintő** (alapértelmezett) - Csak olvasási jog
  - **Szerkesztő** - Olvasás + Létrehozás
  - **Felügyelő** - Olvasás + Létrehozás + Szerkesztés + Törlés
  - **Admin** - Teljes hozzáférés + Rendszerbeállítások
- Jogosultság-ellenőrző metódusok:
  - `canViewList()` - Minden bejelentkezett felhasználó
  - `canCreate()` - Szerkesztő, Felügyelő, Admin
  - `canEdit()` - Felügyelő, Admin
  - `canDelete()` - Felügyelő, Admin
  - `canViewSettings()` - Csak Admin
- Session biztonság:
  - 30 perces timeout (inaktivitás esetén automatikus kijelentkezés)
  - Session cookie biztonság (HttpOnly, Secure flags)
  - Időzóna: Europe/Budapest

---

### 📁 `web/config/` - Konfigurációs fájlok

| Fájl | Funkció |
|------|---------|
| `config.php` | Központi konfiguráció (DB kapcsolat, LDAP beállítások, `.env` alapján) |
| `paths.php` | URL útvonalak definiálása |

---

### 📁 `web/includes/` - Közös include fájlok

| Fájl | Funkció |
|------|---------|
| `header.php` | Közös HTML header (session indítás, Auth.php betöltés, Bootstrap CSS) |
| `footer.php` | Közös HTML footer (Bootstrap JS) |

---

### 📁 `web/assets/` - Frontend statikus fájlok

| Almappa | Tartalom |
|---------|----------|
| `bootstrap/` | Bootstrap 5 CSS és JS framework |
| `fontawesome/` | FontAwesome ikonok |
| `css/` | Egyedi CSS stíluslapok |
| `js/` | Egyedi JavaScript fájlok |
| `img/` | Képfájlok (logók, háttérképek) |

---

### 📁 `db/` - Adatbázis szkriptek

| Fájl | Funkció |
|------|---------|
| **`bktappdb.sql`** | **Fő adatbázis séma** - táblák, nézetek, függvények, triggerek (813 sor) |
| `update_foglalas_function.sql` | `foglalas_matrix_view` nézet HTML/CSS frissítése |
| `load_data.sql` | Kezdő adatok betöltése |
| `info.txt` | Adatbázis információk |

#### Főbb adatbázis táblák (bktappdb.sql):
- `login_log` - Felhasználói bejelentkezések nyilvántartása
- `birosag` - Bíróságok
- `tanacs` - Tanácsok
- `room` - Tárgyalótermek
- `foglalas` - Tárgyalási időpontok
- `foglalas_matrix_view` - Generált HTML mátrix nézet (óránkénti foglaltság)

---

### 📁 `docker-compose/` - Docker konténerek konfigurációja

| Fájl/Mappa | Funkció |
|------------|---------|
| `app-base.yml` | Docker Compose konfiguráció (PHP-FPM, Nginx, PostgreSQL szolgáltatások) |
| `build/` | Docker build fájlok (PHPDockerfile, Nginx konfig) |
| `db/` | Adatbázis inicializálási szkriptek |

#### `app-base.yml` szolgáltatások:
1. **php** konténer - PHP-FPM 8.x, LDAP kiterjesztés, proxy beállítások
2. **nginx** konténer - Webszerver, Traefik reverse proxy integráció
3. **db** konténer - PostgreSQL 14+ adatbázis

---

### 📁 `etc/` - Szolgáltatás konfigurációk

| Almappa | Funkció |
|---------|---------|
| `nginx/` | Nginx webszerver konfiguráció (default.conf) |
| `php/` | PHP konfiguráció (php.ini) |

---

### 📁 `php/` - PHP segédeszközök

| Fájl | Funkció |
|------|---------|
| `helper.php` | PHP helper függvények és segédfüggvények |

---

### 📁 `error_list/` - Hibaelhárítási dokumentáció

| Fájl | Funkció |
|------|---------|
| `error_list.info` | Ismert hibák listája |
| `tanacsok` | Hibaelhárítási tanácsok és megoldások |

---

## Környezet beállítása

### Előfeltételek

#### Windows 11:
1. **BIOS beállítások:**
   - Intel Hyper-Threading Technology engedélyezve

2. **Windows Features:**
   - Hyper-V telepítve/bekapcsolva
   - WSL 2 telepítése:
     ```powershell
     wsl --install -d Ubuntu-24.04
     ```
     Dokumentáció: https://learn.microsoft.com/en-us/windows/wsl/install

3. **Git telepítése:**
   - https://git-scm.com/downloads/win

4. **Docker Desktop telepítése:**
   - https://docs.docker.com/desktop/setup/install/windows-install/

---

### Alkalmazás indítása

1. **Környezeti változók beállítása:**
   Hozz létre egy `.env` fájlt a gyökér könyvtárban:
   ```env
   # PostgreSQL
   POSTGRES_DATABASE=bktappdb
   POSTGRES_USER=your_user
   POSTGRES_PASSWORD=your_password
   
   # LDAP
   LDAP_SERVER=ldap://10.15.49.100
   LDAP_DOMAIN=BIROSAGIAD
   LDAP_BASE_DN=OU=Users,OU=Torvenyszek,OU=BudapestKornyeki_Tvsz,OU=Szervezet,DC=birosagiad,DC=hu
   LDAP_REQUIRED_GROUPS=BKT_TargyaloFoglaloBetekinto, BKT_TargyaloFoglaloSzerkeszto, BKT_TargyaloFoglaloAdmin, BKT_TargyaloFoglaloFelugyelo
   ```

2. **Docker konténerek indítása:**
   ```bash
   cd /srv/containers/test_bkt_tnaptar_app
   docker-compose -f docker-compose/app-base.yml up -d
   ```

3. **Adatbázis inicializálás:**
   ```bash
   docker cp db/bktappdb.sql db:/tmp/
   docker exec -i db psql -U your_user -d bktappdb -f /tmp/bktappdb.sql
   ```

---

### Alkalmazás elérése

- **Helyi elérés (localhost):**  
  `https://localhost:8443/index.php`

- **Production (Traefik reverse proxy):**  
  A `docker-compose/app-base.yml` fájlban definiált Traefik labelek szerint

---

## Funkciók

### Felhasználói szerepkörök (RBAC)

Az alkalmazás **négy szintű hierarchikus jogosultsági rendszert** használ:

| Szerepkör | AD Csoport | Jogosultságok |
|-----------|------------|---------------|
| **Betekintő** | `BKT_TargyaloFoglaloBetekinto` | 👁️ Tárgyalások megtekintése (csak olvasás) |
| **Szerkesztő** | `BKT_TargyaloFoglaloSzerkeszto` | 👁️ Megtekintés<br>➕ Új időpont rögzítése |
| **Felügyelő** | `BKT_TargyaloFoglaloFelugyelo` | 👁️ Megtekintés<br>➕ Létrehozás<br>✏️ Bejegyzések szerkesztése<br>🗑️ Bejegyzések törlése |
| **Admin** | `BKT_TargyaloFoglaloAdmin` | 👁️ Megtekintés<br>➕ Létrehozás<br>✏️ Szerkesztés<br>🗑️ Törlés<br>⚙️ Rendszerbeállítások (bíróságok/tanácsok/termek kezelése) |

**Szerepkör-hierarchia:** Admin > Felügyelő > Szerkesztő > Betekintő

**Auth.php metódusok:**
- `canViewList()` - Minden bejelentkezett felhasználó (betekintő, szerkesztő, felügyelő, admin)
- `canCreate()` - Szerkesztő, Felügyelő, Admin
- `canEdit()` - Felügyelő, Admin
- `canDelete()` - Felügyelő, Admin
- `canViewSettings()` - Csak Admin

---

## Adatbázis séma módosítás

### HTML/CSS stílusok frissítése a `foglalas_matrix_view` nézetben:

1. Szerkeszd a fájlt:
   ```bash
   nano /srv/containers/test_bkt_tnaptar_app/db/update_foglalas_function.sql
   ```

2. Módosítsd a CSS-t (🎨 markerek segítségével):
   ```sql
   -- 🎨 CSS styling (default_html és room_html blokkokban)
   ```

3. Futtasd az update szkriptet:
   ```bash
   docker cp /srv/containers/test_bkt_tnaptar_app/db/update_foglalas_function.sql db:/tmp/
   docker exec -i db psql -U your_user -d bktappdb -f /tmp/update_foglalas_function.sql
   ```

---

## Biztonság

- **LDAP autentikáció** - Active Directory integráció
- **Rate limiting** - 3 sikertelen próbálkozás után 15 perc blokkolás
- **Session timeout** - 30 perc inaktivitás után automatikus kijelentkezés
- **SQL injection védelem** - PDO prepared statements
- **RBAC** - Szerepkör-alapú jogosultságkezelés

---

## Hibaelhárítás

Lásd a `/error_list/` könyvtárat részletes hibaüzenetekhez és megoldásokhoz.

---

## Szerzői információk

- **Fejlesztő:** Birosagi IT Team
- **Verzió:** 1.0
- **Utolsó frissítés:** 2025-12-18

---

## Kapcsolódó dokumentumok

- [info.md](info.md) - Részletes projekt struktúra
- [CLAUDE.md](../helpdesk2.zoli/CLAUDE.md) - AI asszisztens használati útmutató (kapcsolódó projekt)
