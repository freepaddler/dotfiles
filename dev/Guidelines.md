# Guidelines

Version: 1.0

Projects following these guidelines should include near the top of their `README.md`:

> Guidelines: 1.0

## Project Layout

Recommended for all projects

> Example layout: directories are optional. Where applicable, reuse these names
> for the same purposes to keep project structures consistent.

```
project or component root
├── .local/              # gitignored; local project data, e.g.:
│   ├── data/            # application data
│   ├── cache/           # cached files
│   └── backups/         # local backups
├── adl/                 # architecture decision log
├── build/               # gitignored; final and intermediate build artifacts
├── compose/             # Docker Compose sets spanning multiple components
├── deploy/              # deployment configuration and files
├── docs/                # project documentation
├── examples/            # usage examples, configurations and other samples
├── out/                 # gitignored; process outputs, exports and reports
├── resources/           # external resources that cannot be fetched or built
├── scripts/             # scripts for building and maintaining the project
├── testdata/            # shared test data, recommended:
│   ├── http/            # manual HTTP requests
│   ├── samples/         # shared examples and fixtures
│   ├── scenarios/       # manual or automated test scenarios
│   ├── scripts/         # test data preparation scripts
│   ├── generated/       # gitignored; generated test data
│   └── local/           # gitignored; local test data
├── Dockerfile           # default image build
├── Jenkinsfile          # default CI pipeline
├── documentation-map.md # entry point for complex project documentation
├── mise.toml            # project tools, environment and tasks
├── README.md            # human-readable project description
├── TODO.md              # tasks, ideas and technical debt
└── AGENTS.md            # instructions for agents
```

### File Variants

Add a descriptive prefix to the default filename:

```text
├── release.Jenkinsfile
├── service-a.Dockerfile
└── postgres.compose.yml
```

### Docker Runtime

Use either layout for bind mounts.

- **Grouped.** Put service configuration in `config/<service>/` and service data in `volumes/<service>_<mount>/`.
- **Flat.** Put bind mount entries at the runtime root. Name them `<service>_<mount>`, for example `service-a_config/`, `service-a_data/`, or `service-a_lib/`.

Test runtimes use the grouped layout with a dedicated `volumes/` directory for bind-mounted service data. Use `config/` for configuration as needed.

Exclude runtime data directories from the Docker build context using `.dockerignore` when they are inside the context.

Grouped layout example:

```text
runtime/
├── .Caddyfile               # gitignored; local runtime configuration
├── .env                     # gitignored; Compose project settings and shared values
├── .local/                  # gitignored; local runtime configuration
│   └── config/
│       └── <service>/       # local service configuration files
├── compose.yml
├── <service>.env            # environment for one service
├── <scope>.env              # environment shared by a group of services
├── Caddyfile                # single configuration file mounted into a service
├── config/                  # configuration directory mounted into a service
│   └── <service>/           # service config files mounted individually or as a directory
└── volumes/                 # bind-mounted service data; not copied
    ├── service-a_data/
    ├── service-b_data/
    └── service-b_db/
```

## .gitignore

Extend these rules in the root or component-level `.gitignore` files as needed.

```gitignore
.local/
.env
/build/
/out/
/testdata/generated/
/testdata/local/
/volumes/
```

## Artifact Versions and Build Metadata

### Versions

- `X.Y.Z` is the release version (major, minor, patch). Releases use Git tags `vX.Y.Z`.
- Derivative number `n` uses Git tag `vX.Y.Z_n`, Docker tag `X.Y.Z_n`, and package version base `X.Y.Z.n`. Use positive integers for `n` without leading zeros.

### Channels

- **`stable`** publishes release and derivative builds from Git tags. Docker uses `X.Y.Z` for releases and `X.Y.Z_n` for derivatives, with moving tags `X` and `X.Y` for the latest release in each series.
- **`dev`** publishes branch builds. Docker uses `latest`. DEB, APK, Arch, and RPM use the target release version and the build run number.

For target release `X.Y.Z`, build run number `N`, and derivative number `n`:

| Package | `dev`           | `stable` release | `stable` derivative |
| ------- | --------------- | ---------------- | ------------------- |
| DEB     | `X.Y.Z~dev.N-1` | `X.Y.Z-1`        | `X.Y.Z.n-1`         |
| APK     | `X.Y.Z_preN-r0` | `X.Y.Z-r0`       | `X.Y.Z.n-r0`        |
| Arch    | `X.Y.ZpreN-1`   | `X.Y.Z-1`        | `X.Y.Z.n-1`         |
| RPM     | `X.Y.Z~dev.N-1` | `X.Y.Z-1`        | `X.Y.Z.n-1`         |

Within a target release, increasing `N` increases the package version. Reruns keep the same number. Package versions sort in this order: dev builds, the release, its derivatives in order of `n`, then the next patch release.

### Metadata

| Key            | Value                                                       |
| -------------- | ----------------------------------------------------------- |
| `buildDate`    | Actual build time in UTC (RFC 3339)                         |
| `buildCommit`  | Full Git SHA of the source used for the build               |
| `buildRef`     | Full Git ref that triggered the build                       |
| `buildVersion` | `ref_name` without the leading `v`, only for `ref_type=tag` |
| `source`       | Project repository URL                                      |
| `author`       | `Victor Chu <chu@vchu.net>`                                 |

### Build Metadata

| Key            | Startup `BuildInfo` | Docker label                        | Package `build-info.json` | Package field                                             |
| -------------- | ------------------- | ----------------------------------- | ------------------------- | --------------------------------------------------------- |
| `buildDate`    | `buildDate`         | `org.opencontainers.image.created`  | `build_date`              |                                                           |
| `buildCommit`  | `buildCommit`       | `org.opencontainers.image.revision` | `build_commit`            |                                                           |
| `buildRef`     | `buildRef`          | `net.vchu.dev.build.ref`            | `build_ref`               |                                                           |
| `buildVersion` | `buildVersion`      | `org.opencontainers.image.version`  | `build_version`           |                                                           |
| `source`       |                     | `org.opencontainers.image.source`   |                           | `Homepage` (DEB), `url` (APK, Arch), `URL` (RPM)          |
| `author`       |                     | `org.opencontainers.image.authors`  |                           | `Maintainer` (DEB), `maintainer` (APK), `packager` (Arch), `Packager` (RPM) |

- Report `BuildInfo` on binary startup. CI includes `/usr/share/<package-name>/build-info.json` in every package.
- The build run URL is optional artifact metadata (`build_url` in package JSON or `net.vchu.dev.build.url` on the image).
- [OCI image annotations](https://github.com/opencontainers/image-spec/blob/main/annotations.md)

### Actions Variables

| Context key | Environment variable | Use |
| --- | --- | --- |
| `github.sha` | `GITHUB_SHA` | Commit that triggered the run |
| `github.ref` | `GITHUB_REF` | Full Git ref, such as `refs/heads/main` |
| `github.ref_type` | `GITHUB_REF_TYPE` | `branch` or `tag` for builds published by these rules |
| `github.ref_name` | `GITHUB_REF_NAME` | Branch or tag name, such as `main` or `v1.5.0_2` |
| `github.run_number` | `GITHUB_RUN_NUMBER` | Build run number used in development package versions |

Use these names in GitHub Actions and Forgejo Actions. [GitHub Actions variables](https://docs.github.com/en/actions/reference/workflows-and-actions/variables), [Forgejo Actions reference](https://forgejo.org/docs/latest/user/actions/reference/)

## Toolkit

Use mise for tool versions, environment management and project tasks, replacing `Makefile`, `Justfile`, `.env`, `.envrc` and `.tool-versions` where applicable.
