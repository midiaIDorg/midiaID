docker pull tenzerlab/midiaid:latest

rm -rf configs/* && docker compose run -u $(id -u):$(id -g) midia /bin/bash -c "cp -r --no-preserve=mode,ownership /midia/midia_experiments/midia_workspace/midia_pipe/configs-templates/* configs"

