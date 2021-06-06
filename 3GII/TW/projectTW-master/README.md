## HTML operations files
__If input with "=", always one of the values. If not, can be any string__

__When recieving, parameters with "-error" can not be defined__

__All forms need confirmation before making any changes__
### edit-incident.html
Except list-images (can not be defined), this page always recieves the rest of parameters (even the first time)
```
Sending to file: incident.php

3 forms
- Edit status
  - Method: POST
  - Sends:
    - action = edit-status
    - status = pending/checked/completed/unsolvable/solved
  - To be sticky, recieves:
    - status = pending/checked/completed/unsolvable/solved
  - Operation: Change the status of the incident
  - If no errors: Refresh edit-incident.html with new values
  - Permissions: Admin only

- Edit details
  - Method: POST
  - Sends:
    - action = edit-details
    - name
    - description
    - location
    - words
  - To be sticky, recieves:
    - name
      - name-error
    - description
      - description-error
    - location
      - location-error
    - words
      - words-error
  - Operation: Edit the details of the incident
  - If no errors: Refresh edit-incident.html with new values
  - Permissions: Admin/Collaborator

- Add image
  - Method: POST
  - Sends:
    - action = edit-image
  - To be sticky, recives:
    - list-images (array)
      - image (path to image)
  - Operation: Add an image to the incident
  - If no errors: Refresh edit-incident.html with new values
  - Permissions: Admin/Collaborator
```

### new-incident.html
```
Sending to file: incident.php

1 form
- Method: POST
- Sends:
  - action = new
  - name
  - description
  - location
  - words
- To be sticky, recieves:
  - name
    - name-error
  - description
    - description-error
  - location
    - location-error
  - words
    - words-error
- Operation: Create an incident without images, status by default, 
- If no errors: Refresh page defining new parameter "confirm". If the form already sent this parameter, make changes and redirects to edit-incident.html
- Permissions: Admin/Collaborator
```

### edit-user.html
```
Sending to file: user.php

1 form
- Method: POST
- Sends:
  - action = set
  - profilepic (file)
  - name
  - surname
  - email
  - password
  - password-check (must compare with "password")
  - address
  - phoneNumber
  - kind = Colaborator/Administrador
  - status = Activo/Inactivo
  - confirm (can be not defined)
- To be sticky, recieves:
  - profilepic (path)
  - name
    - name-error
  - surname
    - surname-error
  - email
  - password
    - password-error
  - password-check (must compare with "password")
    - password-check-error
  - address
    - address-error
  - phoneNumber
    - phoneNumber-error
  - kind = Colaborator/Administrador
  - status = Activo/Inactivo
- Operation: Edits an existing user
- If no errors: Refresh page defining new parameter "confirm". If the form already sent this parameter, make changes and render operation-result.hmtl
- Permisions: Admin
```

### new-user.html
```
Sending to file: user.php

1 form
- Method: POST
- Sends:
  - action = new
  - profilepic (file)
  - name
  - surname
  - email
  - password
  - password-check (must compare with "password")
  - address
  - phoneNumber
  - kind = Colaborator/Administrador
  - status = Activo/Inactivo
  - confirm (can be not defined)
- To be sticky, recieves:
  - profilepic (path)
  - name
    - name-error
  - surname
    - surname-error
  - email
  - password
    - password-error
  - password-check (must compare with "password")
    - password-check-error
  - address
    - address-error
  - phoneNumber
    - phoneNumber-error
  - kind = Colaborator/Administrador
  - status = Activo/Inactivo
- Operation: Create a new user
- If no errors: Refresh page defining new parameter "confirm". If the form already sent this parameter, make changes and render operation-result.hmtl
- Permisions: Admin
```

### get-db-backup
```
Sending to file: Can be onclick

- Operation: Create a DB backup in form of SQL file and returns it
- Permissions: Admin
```

### incident.html
```
Sending to file: incident.php

- Method: GET
- Sends:
  - action = search
  - search = new/upvotes/votes
  - words
  - place
  - pending = pending (checkbox)
  - checked = checked (checkbox)
  - completed = completed (checkbox)
  - unsolvable = unsolvable (checkbox)
  - solved = solved (checkbox)
  - number = 5/15/25
- Operation: Refresh the page with the search results
- Permissions: Anyone
```

### new-comment.html
__File to be deleted__
__Make sure to ask for confirmation__
```
Onclick
```

### user-management.html
```
Sending to file: user.php

2 forms
- Delete user:
  - Method: POST
  - Sends:
    - action = delete
    - userId
  - Operation: Delete user
  - Permissions: Admin
- Edit user:
  - Method: POST
  - Sends:
    - action = edit
    - userId
  - Operation: Render edit-user.html
  - Permissions: Admin
```
