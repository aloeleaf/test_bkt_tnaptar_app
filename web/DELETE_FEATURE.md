# Delete Functionality Implementation

## Overview
Added group-based authorization for deleting booking entries from the rooms table.

## Features
- ✅ AD group-based authorization (configurable via `LDAP_DELETE_GROUP` env variable)
- ✅ Delete button visible only to authorized users
- ✅ Confirmation page with full entry details before deletion
- ✅ Success/error message feedback
- ✅ Protection against unauthorized access

## Files Modified/Created

### 1. `/web/app/Auth.php`
- Added `canDelete()` method to check if user is in the delete group

### 2. `/web/config/config.php`
- Added `ldap_delete_group` configuration parameter
- Default group: `BKT_Naptar_Admin`

### 3. `/web/list.php`
- Added session start and Auth.php include
- Added delete permission check: `$canDelete = Auth::canDelete()`
- Added delete button (visible only if user has permission)
- Added success/error message display

### 4. `/web/delete_entry.php` (NEW)
- Confirmation page displaying all entry details
- Requires authentication and delete permission
- POST confirmation before actual deletion
- User-friendly Hungarian interface with warnings

## Configuration

Add to your `.env` or docker-compose environment:

```bash
LDAP_DELETE_GROUP=BKT_Naptar_Admin
```

## AD Group Setup

1. Create an AD security group (e.g., `BKT_Naptar_Admin`)
2. Add users who should have delete permissions to this group
3. Set the `LDAP_DELETE_GROUP` environment variable
4. Users in this group will see the delete button on list.php

## Usage Flow

1. User logs in via LDAP
2. User navigates to `list.php`
3. If user is in delete group → Delete button appears
4. Click delete button → Redirects to `delete_entry.php?id=X`
5. Confirmation page shows all entry details
6. User confirms → Entry deleted → Redirected back to list with success message

## Security Features

- ✅ Session-based authentication required
- ✅ AD group membership verification
- ✅ SQL injection protection (prepared statements)
- ✅ XSS protection (htmlspecialchars)
- ✅ Confirmation step prevents accidental deletion
- ✅ Direct URL access blocked if not authorized

## Testing

1. Add test user to the AD delete group
2. Login with that user
3. Verify delete button appears on list.php
4. Click delete → verify confirmation page appears
5. Confirm deletion → verify entry is removed
6. Test with unauthorized user → verify no delete button

## Notes

- Delete is permanent (no soft delete)
- Deletion triggers view refresh automatically
- Bootstrap 5 styling for consistent UI
- FontAwesome icons for visual clarity
