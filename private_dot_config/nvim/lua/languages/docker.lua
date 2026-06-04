return {
    mason = {
        lsp = { 'dockerls', 'docker_compose_language_service' },
        tools = { 'hadolint' },
    },
    lsp = {
        dockerls = {},
        docker_language_server = {},
        docker_compose_language_service = {},
    },
    linters_by_ft = {
        dockerfile = { 'hadolint' },
    },
    filetypes = {
        filename = {
            ['docker-compose.yml'] = 'yaml.docker-compose',
            ['docker-compose.yaml'] = 'yaml.docker-compose',
            ['compose.yml'] = 'yaml.docker-compose',
            ['compose.yaml'] = 'yaml.docker-compose',
        },
        pattern = {
            ['docker%-compose.*%.ya?ml'] = 'yaml.docker-compose',
            ['.*%-compose.*%.ya?ml'] = 'yaml.docker-compose',
            ['compose%-.*%.ya?ml'] = 'yaml.docker-compose',
            ['compose%..*%.ya?ml'] = 'yaml.docker-compose',
            ['%.compose.*%.ya?ml'] = 'yaml.docker-compose',
            ['.*%.compose.*%.ya?ml'] = 'yaml.docker-compose',
        },
    },
}
