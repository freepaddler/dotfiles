# AI Models Reference

Current shell AI setup:

- `qwen-cli` -> `qwen3.5:4b`
- `qwen-fast` -> `qwen2.5-coder:7b`
- `qwen-max` -> `qwen-fast` with larger context/output limits

Routing:

- CLI requests without stdin/files use `qwen-cli`
- Data-mode requests with stdin/files use `qwen-fast`
- Oversized data-mode requests can switch to `qwen-max`

Why:

- `qwen3.5:4b` works well for short CLI command generation
- `qwen3.5:4b` was unstable for data-mode analysis in this shell workflow
- `qwen2.5-coder:7b` remains more reliable for incident/diff/input analysis

Current profile settings:

`qwen-cli`
- base: `qwen3.5:4b`
- `num_ctx 4096`
- `num_predict 96`
- `presence_penalty 0`
- `temperature 0.1`
- `top_p 0.9`
- `repeat_penalty 1.1`

`qwen-fast`
- base: `qwen2.5-coder:7b`
- `num_ctx 8192`
- `num_predict 512`
- `presence_penalty 0`
- `temperature 0.2`
- `top_p 0.9`
- `repeat_penalty 1.1`

`qwen-max`
- base: `qwen-fast`
- `num_ctx 32768`
- `num_predict 2048`
- `presence_penalty 0`

Shell wrapper notes:

- config: `~/.config/shell/rc/ai`
- input limit: `AI_CONTEXT_MAX_KB=96`
- `/no_think` is applied only to the CLI route
- `incident` and `diff` prompts were tightened to prefer findings-first output

Related files:

- `~/.ollama/modelfiles/qwen-cli.Modelfile`
- `~/.ollama/modelfiles/qwen-fast.Modelfile`
- `~/.ollama/modelfiles/qwen-max.Modelfile`
- `~/.config/shell/rc/ai`
- `~/.config/opencode/opencode.json`
