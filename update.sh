#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )


for version in "${versions[@]}"; do	
  if [ "${version%%.*}" -ge 3 ]; then
  	url="http://repo.mongodb.org/apt/ubuntu"
    fullVersion="$(curl -fsSL "${url}/dists/trusty/mongodb-org/$version/multiverse/binary-amd64/Packages.gz" | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^mongodb-(org(-unstable)?|10gen)$/ && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
    fullRepository="${url} trusty/mongodb-org/${version} multiverse"
  else
  	url="http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
    fullVersion="$(curl -fsSL "${url}/dists/dist/10gen/binary-amd64/Packages.gz"                             | gunzip | awk -F ': ' '$1 == "Package" { pkg = $2 } pkg ~ /^mongodb-(org(-unstable)?|10gen)$/ && $1 == "Version" { print $2 }' | grep "^$version" | sort -rV | head -n1 )"
	  fullRepository="${url} dist 10gen"
	fi
	(
		set -x
		cp docker-entrypoint.sh "$version/"
		sed '
			s/%%MONGODB_MAJOR%%/'"$version"'/g;
			s/%%MONGODB_VERSION%%/'"$fullVersion"'/g;
			s!%%MONGODB_REPOSITORY%%!'"$fullRepository"'!g;
		' Dockerfile.template > "$version/Dockerfile"
	)
done
