<p align="center">
  <big><strong>Off-chain metadata tools</strong></big>
</p>

<p align="center">
  <img width="200" src=".github/images/cardano-logo.png"/>
</p>

<p align="center">
  <a href="https://buildkite.com/input-output-hk/offchain-metadata-tools"><img src="https://badge.buildkite.com/7df25c563faffd8c7b09db8d802a73bd2ebc14ace98a432761.svg" alt="Build status"></a>
</p>

## Overview

In the Cardano multi-asset era, this project helps you create and
submit metadata describing your assets, storing them off-the-chain.

It provides a reference implementation for [this draft CIP](https://github.com/michaelpj/CIPs/blob/cip-metadata-server/cip-metadata-server.md).

## Disambiguation

This metadata is used to describe "assets" (see
[here](https://docs.cardano.org/en/latest/native-tokens/learn-about-native-tokens.html)).
Assets, most-often known as tokens, are represented on-the-chain by
their asset ID, which look something like this:
"7c8d07d69639e9413dd637a1a815a7323c69c86abbafb66dbfdb1bb6". Asset IDs
are not very user-friendly, so this metadata provides a mapping
between the on-chain asset ID and more user-friendly information
off-chain.

This metadata is not to be confused with on-chain transaction
metadata. Transaction metadata is included with each transaction and
stored "on-the-chain". Transaction metadata is used for a variety of
purposes, hence the confusion.

## Components

This project consists of a number of components:
  - token-metadata-creator
    - Asset/Token metadata creation and validation
  - metadata-server
    - Server for retrieving metadata from the storage layer
  - metadata-store-postgres
    - Postgres metadata storage layer
  - metadata-webhook
    - GitHub webhook that writes metadata to the storage layer
  - metadata-validator-github
    - Simple validator used to ensure that GitHub PRs are in a format appropriate for the webhook
  - metadata-lib
    - shared library for common metadata needs

## Pre-built binaries:

See [our releases](https://github.com/input-output-hk/offchain-metadata-tools/releases) for stable binaries.

For the bleeding-edge the following are available (use these with caution):

  - [token-metadata-creator](https://hydra.iohk.io/job/Cardano/offchain-metadata-tools/musl64.token-metadata-creator-tarball.x86_64-linux/latest/download/1)
  - [metadata-validator-github](https://hydra.iohk.io/job/Cardano/offchain-metadata-tools/musl64.metadata-validator-github-tarball.x86_64-linux/latest/download/1)

## Building

See [the docs](https://input-output-hk.github.io/offchain-metadata-tools/#build-the-project-from-source).

## Documentation

| Link | Contents |
| --- | --- |
| [API Documentation](https://input-output-hk.github.io/offchain-metadata-tools/api/latest) | Specification of the metadata-server API |
| [Manual](https://input-output-hk.github.io/offchain-metadata-tools/) | Everything else |
