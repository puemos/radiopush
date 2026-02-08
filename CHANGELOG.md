# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.2] - 2026-02-08

### Added

- Local development workflow with Docker Compose for Postgres
- Platform LiveView coverage for guest and authenticated navigation

### Changed

- Upgraded to Elixir 1.19 and Phoenix 1.8 ecosystem dependencies
- Migrated UI from Surface components to Phoenix components/HEEx
- Replaced `spotify_ex` integration with a `Req`-based Spotify auth/client flow
- Updated frontend build tooling versions (esbuild, tailwind, dart_sass)
- Updated Docker runtime/build images for newer Elixir/OTP/Debian

## [0.2.1] - 2021-19-08

### Chore

- Upgrade Surface
- Remove Album code
- Upgrade mix deps

### Security

- Audit fix for npm deps

## [0.2.0] - 2021-12-08

### Added

- Show duration and BPM for new songs
- Changelog :)
