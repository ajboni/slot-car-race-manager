#!/bin/sh

## Start Docker containers
docker-compose up -d && 
    x-terminal-emulator --command "export FLASK_SKIP_DOTENV=1 && cd server && python3 app.py; sleep 5";
    x-terminal-emulator --command " cd client && yarn start; sleep 5";
# x-terminal-emulator --command "cd client && ls";
# x-terminal-emulator -x cd ./server && ls | x-terminal-emulator -x cd ./client && ls

# python3 ./server/app.py; cd ./client && yarn start

## Excute client
