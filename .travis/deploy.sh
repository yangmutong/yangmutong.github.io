#!/bin/bash

openssl aes-256-cbc -K $encrypted_df4850c8164c_key -iv $encrypted_df4850c8164c_iv -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d

chmod 600 ~/.ssh/id_rsa

eval $(ssh-agent)

ssh-add ~/.ssh/id_rsa

cp .travis/ssh_config ~/.ssh/config

git config --global user.name "yangmutong"
git config --global user.email 985777876@qq.com