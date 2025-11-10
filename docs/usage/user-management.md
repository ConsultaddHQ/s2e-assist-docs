---
id: user-management
title: User Management
sidebar_label: User Management
---

# User Management

The S2E includes a built-in CLI for managing users inside the container.  
This guide covers how to create user accounts.

---

## Why use this CLI?

- There is **no public signup UI** for the tool.
- User management is restricted to trusted administrators.

---

## Prerequisites

- The Seamless Upgrade Tool container is running.
- You have Docker or Podman access to the host machine.

Check running containers:

```bash
docker ps
````

Expected output:

```
CONTAINER ID   NAME                   STATUS
1234abcd5678   s2e-backend  Up 5 minutes
```

---

## Creating a User

### Docker

```bash
docker exec -it s2e-backend ./createUser
```

You will be prompted for:
* **name**
* **Username**
* **Password**
* **Roles** (Use space to select)

```

---

## Need Help?

If you're having issues running the script, ensure:

* The container is running and healthy.
* You are using the correct container name (e.g. `s2e-backend`).
