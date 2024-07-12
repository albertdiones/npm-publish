#!/bin/bash

# Dependencies: git, jq, semver, npm

# Navigate to the package directory
cd $1 || exit

# Git commit any uncommitted changes
git add .

# Get the name and current version from package.json
PACKAGE_NAME=$(jq -r ".name" package.json)
CURRENT_VERSION=$(jq -r ".version" package.json)


git commit -m "Update ${PACKAGE_NAME}"

echo "Current version: ${CURRENT_VERSION}"

# Increment the version (assuming you're using semantic versioning)
NEW_VERSION=$(semver -i patch "$CURRENT_VERSION")

# Update the package.json version
jq ".version = \"$NEW_VERSION\"" package.json > temp.json && mv temp.json package.json

# Commit the version update
git add package.json
git commit -m "Bump version to $NEW_VERSION"

# Tag the current HEADgq
git tag "v$NEW_VERSION"

# Push changes and tags
git push origin main --tags

# Publish to npm
npm publish
