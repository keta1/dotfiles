# Agent Guide

## Scope

This file applies to the whole repository.

## Repository Context

This is a personal dotfiles repository managed with Nix, nix-darwin, and Home
Manager. The flake links selected files from this checkout into the user's home
directory.

## Working Rules

- Keep secrets, private keys, tokens, and machine-local credentials out of this
  repository.
- Preserve the existing directory layout unless a change clearly needs a new
  module or managed file.
- Do not edit `flake.lock` unless the task is specifically about updating
  inputs or dependencies.
- Treat `codex/config.toml` as local-only configuration; it is intentionally
  gitignored.
- Prefer small, focused changes that match the existing Nix module style.

## Commit Convention

Use Conventional Commits for commit messages:

```text
<type>(optional scope): <description>
```

Common types:

- `feat`: add a user-facing feature or managed configuration.
- `fix`: correct broken behavior.
- `docs`: update documentation only.
- `style`: formatting-only changes.
- `refactor`: restructure code or configuration without changing behavior.
- `chore`: maintenance tasks, dependency updates, or tooling changes.

Use an imperative, lowercase description when practical, for example:

```text
docs: add agent guide
feat(fish): add shell aliases
fix(darwin): correct dock defaults
```

## Useful Commands

```sh
darwin-rebuild build --flake .#Ketals-MacBook-Pro
```

```sh
sudo darwin-rebuild switch --flake .#Ketals-MacBook-Pro
```

Run the `switch` command only when the user explicitly wants to apply the
configuration on this machine.
