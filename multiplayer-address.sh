#!/bin/bash

docker logs mc-ngrok 2>&1 | grep -o "url=tcp://[a-zA-Z0-9.-]*:[0-9]*" | sed 's|url=tcp://||' | tail -n 1
