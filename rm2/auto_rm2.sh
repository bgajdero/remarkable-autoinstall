set -e
APPDIR=${APPDIR:-/home/root/apps}
REPOURL="https://raw.githubusercontent.com/ddvk/remarkable-autoinstall/master/rm2"
RM2FBREPO="https://github.com/ddvk/remarkable2-framebuffer/releases/download/v0.0.2"
KOREADER="http://build.koreader.rocks/download/nightly/v2020.12-76-geb66856_2021-01-02/koreader-remarkable-v2020.12-76-geb66856_2021-01-02.zip"

mkdir -p $APPDIR
mkdir -p ~/scripts

systemctl stop touchinjector || true

echo "Downloading files..."

if [ ! -d "$APPDIR/koreader" ]; then
    mkdir -p "$APPDIR/koreader"
    wget "$KOREADER" -O /tmp/koreader.zip
    unzip /tmp/koreader.zip -d $APPDIR
fi

wget "$RM2FBREPO/librm2fb_client.so.1.0.0" -O ~/librm2fb_client.so.1.0.0
wget "$RM2FBREPO/librm2fb_server.so.1.0.0" -O ~/librm2fb_server.so.1.0.0
wget "$REPOURL/apps/touchinjector" -O ~/apps/touchinjector
wget "$REPOURL/scripts/swipeup.sh" -O ~/scripts/swipeup.sh
wget "$REPOURL/scripts/ko.sh" -O ~/scripts/ko.sh

chmod +x ~/scripts/swipeup.sh
chmod +x ~/scripts/ko.sh
chmod +x ~/apps/touchinjector


echo "Systemd unit file"
cat << EOF > /etc/systemd/system/touchinjector.service
[Unit]
Description=touch injector
After=home.mount

[Service]
Environment=HOME=/home/root
ExecStart=$APPDIR/touchinjector

[Install]
WantedBy=multi-user.target
EOF

echo "Starting the touch service..."
systemctl daemon-reload
systemctl enable touchinjector
systemctl start touchinjector

echo "Started touch gestures, you can long swipe up to switch to koreader"
