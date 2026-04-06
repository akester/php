#!/bin/bash

set -e
set -x

git checkout 8.1 && git cherry-pick $1 && git push && git checkout latest
git checkout 8.2 && git cherry-pick $1 && git push && git checkout latest
git checkout 8.3 && git cherry-pick $1 && git push && git checkout latest
git checkout 8.4 && git cherry-pick $1 && git push && git checkout latest
git checkout 8.5 && git cherry-pick $1 && git push && git checkout latest
