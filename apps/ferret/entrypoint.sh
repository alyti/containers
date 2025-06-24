#!/usr/bin/env bash

export CONFIG_DIR="/data/run"

function setToken {
    local network="$1"
    local token="$2"
    if [[ -z "${token}" ]]; then
        echo "Token for '${network}' network is empty, generating a new one."
        genToken "${network}"
    else
        echo "Setting token for '${network}' network to '${token}'."
        cat <<< $(jq '.\"${network}\".token = \"${token}\"' "${CONFIG_DIR}/networks.json") > "${CONFIG_DIR}/networks.json"
    fi
}

function genToken {
    local network="$1"
    local token=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w 50 | head -n 1)
    cat <<< $(jq '.\"${network}\".token = \"${token}\"' "${CONFIG_DIR}/networks.json") > "${CONFIG_DIR}/networks.json"
    echo "Created token for '${network}' network: ${token}"
}


if [[ ! -f "${CONFIG_DIR}/config.json" ]]; then
    mkdir -p "${CONFIG_DIR}"
    cp /defaults/* "${CONFIG_DIR}/"

    genToken "main"
fi

[[ -n "${FERRET__TOKEN}" && -n "${FERRET__NETWORK}" ]] && setToken "${FERRET__NETWORK}" "${FERRET__TOKEN}"

exec \
    /usr/bin/node \
        "/app/src/index.js"
