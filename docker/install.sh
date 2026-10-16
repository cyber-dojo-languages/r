#!/bin/sh -eu

# Installs the newest R from CRAN's own Ubuntu repository rather than the one
# Ubuntu's archive froze at its release. CRAN keeps one repository per Ubuntu
# release, named <codename>-cran40, built for amd64 and arm64, and it carries
# the current R release, so no version is named here and a rebuild picks up
# the next release by itself.

apt-get update
apt-get install --yes --no-install-recommends curl ca-certificates

. /etc/os-release
readonly CODENAME="${VERSION_CODENAME}"

# apt reads an ASCII-armored key directly when its name ends in .asc, so the
# key needs no gpg to dearmor it.
mkdir -p /etc/apt/keyrings
curl --silent --fail https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  > /etc/apt/keyrings/cran.asc
echo "deb [signed-by=/etc/apt/keyrings/cran.asc] https://cloud.r-project.org/bin/linux/ubuntu ${CODENAME}-cran40/" \
  > /etc/apt/sources.list.d/cran.list

apt-get update
apt-get install --yes r-base

# apt's package lists are left in place: the image built on this one installs
# its test framework with apt-get install and relies on them.

# Records the R this image holds, in the shape every image shares. The
# installed interpreter is asked, so the version is one the image can run
# rather than one written down when someone last edited this file.
readonly LANGUAGE_VERSION=$(Rscript -e 'cat(format(getRversion()))')

if [ -z "${LANGUAGE_VERSION}" ]; then
  echo 'Could not read a version from getRversion()' >&2
  exit 1
fi

cat > /versions.json <<EOF
{
  "language": {
    "name": "R",
    "version": "${LANGUAGE_VERSION}"
  },
  "test_frameworks": []
}
EOF
