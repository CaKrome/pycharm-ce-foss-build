#!/bin/bash

pycharm_version=$(cat pycharm_ver)

# Download PyCharm and Android plugin(required for building PyCharm)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/pycharm/$pycharm_version.tar.gz -O pycharm-source.tar.gz
git clone --depth 1 --branch pycharm/$pycharm_version git://git.jetbrains.org/idea/android.git

# Extract files

tar -xf pycharm-source.tar.gz
rm -rf android/.git/
find android/ -type f -exec sha256sum {} + | awk '{print $1}' | sort | sha256sum | awk '{print $1}' > checksum_bv
if [[ $(cat checksum_bv) == $(cat checksum_android) ]]
then
  echo "Android plugin checksum verification completed"
  echo "Checksum is $(cat checksum_bv)"
  mv android intellij-community-pycharm-$pycharm_version

  # Some needed modifications

  cd intellij-community-pycharm-$pycharm_version

  sed '/String targetOS/c   String targetOS = OS_LINUX' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/BuildOptions.groovy
  sed 's|../build/plugins-autoupload.txt|plugins-autoupload.txt|' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/impl/DistributionJARsBuilder.groovy
  touch plugins-autoupload.txt
  sed 's|intellij.pycharm.community.build|"$(cd "$(dirname "$0")"; pwd)/../" intellij.pycharm.community.build|' -i python/installers.cmd

  echo $pycharm_version > build.txt

  # Build

  ./python/installers.cmd -Dintellij.build.target.os=linux

  # Clean up
  cd ..
  rm pycharm-source.tar.gz
  rm checksum_bv

else
  echo "Downloaded Android plugin maybe corrupted."
fi
