# LLM Image


This project builds a Docker image on top of `ollama/ollama:0.18.0` with:

- `qwen3.5:0.8b` pulled into Ollama
- `opencode` installed from `opencode-ai`
- `openclaw` installed
- `ollama/qwen3.5:0.8b` set as the default OpenClaw model

## Build

```
docker build -t llmdemo:v1.0 .
```

## Run

```
docker run -d --name llmdemo -p 11434:11434 llmdemo:v1.0
```

The container starts with Ollama serving on port `11434`.
