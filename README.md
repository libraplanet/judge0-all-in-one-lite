# judge0-all-in-one-lite

A compact, all-in-one Docker image bundling **Judge0 API**, **Judge0 IDE**, and **SQLite**.

---

## Features

- 🧩 Judge0 API + IDE integrated behind a single HTTP port (80)
- 🗂️ Persistent SQLite database at `/var/lib/judge0/judge0.db`
- 🧑 Runs under host `judge0:judge0` user via `--user`
- 🐋 Alpine-based lightweight Docker image

---

## Getting Started

### 1. Prepare host volume with correct UID/GID

```bash
sudo mkdir -p /var/lib/judge0
sudo chown judge0:judge0 /var/lib/judge0
```

## Acknowledgements

This project bundles the following upstream open-source projects:

- [Judge0 API](https://github.com/judge0/judge0) – An open-source online code execution system.
- [Judge0 IDE](https://github.com/judge0/ide) – A simple frontend for the Judge0 API.

We gratefully acknowledge the work of the Judge0 maintainers and community.
