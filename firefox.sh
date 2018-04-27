#!/bin/sh

# === Script downloads Mozilla Firefox old version with Java support ===

# Firefox's version to download
version="42.0"

# Firefox's language pack
language="en-US"

# Target folder where you're gonna to put your old Firefox folder
targetFolder="${HOME}"

# Firefox folder by version
ffFolder="firefox-$version"

if ! [ -d $targetFolder ]; then
    mkdir -p $targetFolder
fi;

if [ -d $targetFolder/$ffFolder  ]; then
    # Run Firefox

    # If you're wonna firefox to start with default page then set it before in env var FIREFOX_DEFAULT_PAGE                                                    
    cd $targetFolder;
    exec "$ffFolder/firefox" -profile "$ffFolder/profile" -new-instance $FIREFOX_DEFAULT_PAGE 
else
    # Install old firefox if not exists
    echo "Install Firefox $version language $language to $targetFolder/$ffFolder\n";

    # Get Firefox from officials
    file="firefox-$version.tar.bz2"
    url="https://ftp.mozilla.org/pub/firefox/releases/$version/linux-x86_64/$language/$file"
    cd $targetFolder
    wget $url
    tar jxfv $file
    rm $file
    mv firefox $ffFolder
    chmod +x "$ffFolder/firefox"

    # Create user.js to override default options to prevent auto updates
    # we should keep old firefox version
    profileFolder="$targetFolder/$ffFolder/profile"
    mkdir -p $profileFolder
cat > $profileFolder/user.js << 'EOF'
pref("app.update.auto", false);
pref("app.update.enabled", false);
pref("app.update.silent", false);
EOF

    # First run
    echo "\nFirst Firefox running\nPlease turn on Java Plugin on the Plugins tab\n" 
    exec "$ffFolder/firefox" -profile "$ffFolder/profile" -new-instance about:addons
fi;
