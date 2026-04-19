# Workflow Scripts

These helpers exist to reduce drift between the live n8n instance and the exported workflow JSON in the repo.

They are intentionally small and honest:

- `export-active-from-docker.sh`: exports the 7 active CrispyBrain workflows from a running Docker-based n8n container into `crispybrain/workflows`
- `import-exported-into-docker.sh`: imports the exported workflow JSON into a running Docker-based n8n container
- `post-import-checklist.sh`: prints the operator checklist that still must be completed manually

These scripts do not create credentials automatically and they do not promise a full one-command deployment.
