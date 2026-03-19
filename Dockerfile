FROM ollama/ollama:0.18.0
# starting images

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/root

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git gnupg \ 
    # install curl and git
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
        | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" \
        > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g opencode-ai openclaw \ 
    # install opencode and openclaw
    && npm cache clean --force \
    && apt-get purge -y --auto-remove gnupg \
    && rm -rf /var/lib/apt/lists/*

RUN export OLLAMA_HOST=127.0.0.1:11434 \
    && ollama serve > /tmp/ollama-build.log 2>&1 & \
    pid=$! \
    && for i in {1..60}; do \
        if curl -fsS "http://${OLLAMA_HOST}/api/tags" > /dev/null; then \
            break; \
        fi; \
        sleep 1; \
    done \
    && ollama pull qwen3.5:0.8b \ 
    # specify the LLM models
    && kill "${pid}" \
    && wait "${pid}" || true

RUN openclaw config set agents.defaults.model.primary ollama/qwen3.5:0.8b
