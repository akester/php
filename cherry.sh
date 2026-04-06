#!/bin/bash

set -e
set -x

git checkout 8.1 && git merge latest && git push && git checkout latest
git checkout 8.2 && git merge latest && git push && git checkout latest
git checkout 8.3 && git merge latest && git push && git checkout latest
git checkout 8.4 && git merge latest && git push && git checkout latest
git checkout 8.5 && git merge latest && git push && git checkout latest
