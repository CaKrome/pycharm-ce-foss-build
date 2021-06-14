#!/bin/bash

pycharm_version=211.7442.45
android_plugin_version=211.7442.13

# Download PyCharm and Android plugin(required for building PyCharm)

wget https://github.com/JetBrains/intellij-community/archive/refs/tags/pycharm/211.7442.45.tar.gz -O pycharm-source.tar.gz
wget https://github.com/JetBrains/android/archive/refs/tags/pycharm/211.7442.13.tar.gz -O android-pycharm-source.tar.gz

# Extract files

tar -xvf pycharm-source.tar.gz
tar -xvf android-pycharm-source.tar.gz
mv android-pycharm-$android_plugin_version android
mv android intellij-community-pycharm-$pycharm_version

# Some needed modifications

cd intellij-community-pycharm-$pycharm_version

# https://youtrack.jetbrains.com/issue/IDEA-266631 (Removal of non-free plugins)
sed '/intellij.cwm.plugin/d' -i python/build/plugin-list.txt
sed '/intellij.marketplace/d' -i python/build/plugin-list.txt

sed '/def targetOs =/c def targetOs = "linux"' -i build/dependencies/setupJbre.gradle
sed '/String targetOS/c   String targetOS = OS_LINUX' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/BuildOptions.groovy
sed -E 's|(<sysproperty key="jna.nosys")|<sysproperty key="intellij.build.target.os" value="linux" />\1|' -i build.xml
sed -E 's|(<sysproperty key="java.awt.headless")|<sysproperty key="intellij.build.target.os" value="linux" />\1|' -i python/build.xml
sed "s/-Xmx612m -XX:MaxPermSize=152m/-Xmx2048m -XX:MaxPermSize=512m/" -i python/build.xml
sed 's|../build/plugins-autoupload.txt|plugins-autoupload.txt|' -i platform/build-scripts/groovy/org/jetbrains/intellij/build/impl/DistributionJARsBuilder.groovy
touch plugins-autoupload.txt
echo $pycharm_version > build.txt

# Build

cd python
ant -Dintellij.build.target.os=linux build

# Clean up

cd ../../
rm pycharm-source.tar.gz
rm android-pycharm-source.tar.gz
