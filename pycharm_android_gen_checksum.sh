#!/bin/bash

pycharm_version=$(cat pycharm_ver)

mkdir workspace
cd workspace

git clone --depth 1 --branch pycharm/$pycharm_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} + | awk '{print $1}' | sort | sha256sum | awk '{print $1}' > checksum_1
rm -rf android/

git clone --depth 1 --branch pycharm/$pycharm_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} + | awk '{print $1}' | sort | sha256sum | awk '{print $1}' > checksum_2
rm -rf android/

git clone --depth 1 --branch pycharm/$pycharm_version git://git.jetbrains.org/idea/android.git
rm -rf android/.git/
find android/ -type f -exec sha256sum {} + | awk '{print $1}' | sort | sha256sum | awk '{print $1}' > checksum_3
rm -rf android/

if [[ $(cat checksum_1) == $(cat checksum_2) ]] && [[ $(cat checksum_2) == $(cat checksum_2) ]]
then
  cat checksum_1 > ../checksum_android
  echo "The checksum is $(cat checksum_1)"
else
  echo "Something might went wrong."
fi

cd ..
rm -rf workspace
