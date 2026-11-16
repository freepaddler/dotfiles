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

Example layout: use entries where applicable.

> When building from the project root, exclude `volumes/` from the build context using `.dockerignore`.

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

## Toolkit

Use mise for tool versions, environment management and project tasks, replacing `Makefile`, `Justfile`, `.env`, `.envrc` and `.tool-versions` where applicable.
