# Slidev Replicate

Example workflow:

- I have a repo `2024-modern-linux-cli-tools`
- I create a dedicated branch for each instance of this talk. Example branch name: `2024-09-socrates-day-franken`
- Switch to that branch.
- Update "occasion" info's
  - header ("occasion URL")
  - logo
  - qr code
- Create an empty target repo
- Add target repo to `SLIDEV_TOKEN` | This is within the GH-User Profile Settings!
  - TODO Can this be scripted?? It requires GH-Admin privileges!
  - Personal Access Tokens -> [Fine-grained tokens](https://github.com/settings/personal-access-tokens)
  - The token must grant the following permissions:
    - Read access to `metadata`
    - Read and write access to:
      - actions
      - administration
      - code
      - commit statuses
      - deployments
      - merge queues
      - pages
      - pull requests
- Create new gh-action
- Patch branch-name, target repo name
- Push

The [bash script](./slidev-replicate.bash) currently handles everything except the

- slidev custom stuff:
  - occasion in header
  - logo
  - qr code
- token handling
- I still have to add the newly generated repo to the `SLIDEV_TOKEN` manually. This implies that the first run will always fail.
