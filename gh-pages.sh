#!/bin/bash
set -e

rm -rf gh-pages || exit 0;

mkdir -p gh-pages

cd example
elm make Main.elm --yes --output assets/elm.js

cp -r assets ../gh-pages
cp index.html ../gh-pages

# init branch and commit
cd ../gh-pages
git init
git add .
git commit -m "Deploying to GH Pages"
git push --force "git@github.com:w0rm/elm-slice-show.git" master:gh-pages
