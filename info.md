# Project Structure: test_bkt_tnaptar_app

This document provides an overview of the directory and file structure for the `test_bkt_tnaptar_app` project.

## Root Directory
- `README.md`: Project documentation.
- `.gitignore`: Git ignore rules.
- `test_bkt_tnaptar_app.code-workspace`: VS Code workspace settings.

## Main Folders
- `db/`: Database scripts and info.
  - `bktappdb.sql`, `load_data.sql`, etc.
- `docker-compose/`: Docker Compose configuration files.
  - `app-base.yml`, `build/`, `db/`
- `error_list/`: Error documentation and advice.
  - `error_list.info`, `tanacsok`
- `etc/`: Configuration files for services.
  - `nginx/`, `php/`
- `php/`: PHP helper scripts.
  - `helper.php`
- `web/`: Main web application files.
  - `dashboard.php`, `index.php`, `list.php`, `room_bookings.php` (displays bookings for a given room), etc.
  - `app/`: API and backend PHP scripts.
  - `assets/`: Static assets (CSS, JS, images, fonts).
  - `config/`: App configuration files.
  - `includes/`: Common includes (header, footer).
  - `phpMyAdmin/`: phpMyAdmin tool and related files.

## Notable Subfolders
- `web/app/`: Contains API endpoints and backend logic.
- `web/assets/`: Contains static files for frontend (Bootstrap, FontAwesome, custom CSS/JS).
- `web/config/`: Configuration for the web app.
- `web/includes/`: Shared PHP includes.
- `web/phpMyAdmin/`: Third-party phpMyAdmin tool.

## Example Structure
```
README.md
.gitignore
db/
docker-compose/
error_list/
etc/
php/
web/
```

Refer to this file for a quick overview of the project layout and key components.