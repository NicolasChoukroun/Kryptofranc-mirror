#!/bin/bash
echo "--------------------------------------------------------------"
echo "bitFranc Installer: version 1.22"
echo "installer [option1] [option2] [option3] [option3]"
echo "  win       compile for Windows os "
echo "  unix      compile for Unix (default)"
echo "  install   install and update the dependencies (default = no)"
echo "  clone     clone bitcoin in its working directory (default = no)"
echo "  extras    install extras (vsftpd for example) (default = no)"
echo "  noexec    do not execute the wallet at the end (default = no)"
echo "  copy      update the bitcoin directory with the assets_installer changes (default = no)"
echo
echo "example: ./installer.sh install noexec clone copy"
echo "will compile for unix, install qt, git db4 etc.. clone git bitcoin, and copy the bifFranc changes over it."
echo "--------------------------------------------------------------"

# initialize the internal variables

OS="unix"
INSTALL="no"
COPY="no"
CLONE="no"
EXTRAS="no"
NOEXEC="no"


# test the number max of options

if [ "$#" -le 1 ] ; then
   	echo "exiting..."
fi
if [ "$#" -ge 5 ]  ; then
	echo "Error: too many parameters (5 max)"
	exit
fi

# loop through all the options and set the corresponding variables
while [ "$1" != "" ]; do
	case $1 in
	    win)
	    OS="windows"
	     ;;
	    copy)
	    COPY="yes"
	     ;;
	    install)
	    INSTALL="yes"
	     ;;
	    noexec)
	    NOEXEC="yes"
	     ;;
	    extras)
	    EXTRAS="yes"
	     ;;
	    help)
	    exit
	    ;;
	esac
	shift
done
	
echo "--------------------------------------------------"
echo " *** EXECUTING SCRIPT WITH OPTIONS ***"
echo "OS=$OS"
echo "INSTALL=$INSTALL"
echo "COPY=$COPY"
echo "CLONE=$CLONE"
echo "EXTRAS=$EXTRAS"
echo "NOEXEC=$NOEXEC"
echo "--------------------------------------------------"

exit

if [ $INSTALL="yes" ]; then
    echo "--------------------------------------------------"
    echo "Install option executing (install option is on)..."

    sudo apt-get --assume-yes update
    sudo apt-get --assume-yes upgrade
    sudo apt-get --assume-yes install git
    sudo apt-get --assume-yes install build-essential
    sudo apt-get --assume-yes install qt5-default qttools5-dev-tools
    sudo apt-get --assume-yes install autoconf libtool pkg-config libboost-all-dev libssl-dev libprotobuf-dev protobuf-compiler libevent-dev libqt4-dev libcanberra-gtk-module
    sudo cp -r bitcoin ~/
fi

if [ $CLONE="yes" ]; then
    echo "--------------------------------------------------"
    echo "Cloning bitcoin core locally (clone option is on)..."

    sudo cd
    sudo rm -r -f bitcoin
    sudo git clone https://github.com/bitcoin/bitcoin 
fi

if [ $EXTRAS="yes" ]; then
    echo "--------------------------------------------------"
    echo "Extras Installation..."
    sudo apt update
    sudo apt-get install hardinfo
    sudo apt install software-center*
    sudo apt-get isntall git-core
    git.config --global.username "bitFranc"
    echo "I need you GIT user email so that later on you push with your name:"
    read GITUSER
    git.config --global user.email $GITUSER
    snap install ubuntu-mate-welcome --classic
    snap install software-boutique --classic
    snap install pulsemixer
    sudo apt install vsftpd
    sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
    sudo ufw allow 20/tcp
    sudo ufw allow 21/tcp
    sudo ufw allow 990/tcp
    sudo ufw allow 40000:50000/tcp
    sudo ufw allow 80:tcp
    sudo yfw allow 443:tcp
    echo "Please enter a login/user for the FTP:"
    read FTPLOGIN
    sudo adduser $FTPLOGIN
    sudo mkdir /home/$FTPLOGIN/ftp
    sudo mkdir /home/$FTPLOGIN/http
    sudo chown nobody:nogroup /home/$FTPLOGIN/ftp
    sudo chown nobody:nogroup /home/$FTPLOGIN/http
    sudo chmod +rw /home/$FTPLOGIN/ftp
    sudo chmod +rw /home/$FTPLOGIN/http
    sudo openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem
    cp assets_installer/vsftpd.conf /etc/vsftpd.conf
    cp assets_installer/vsftpd.pem /etc/ssl/private/vsftpd.pem
    systemctl restart vsftpd

fi

if [ $COPY="yes" ]; then
    $MOD="-u"
fi

echo "--------------------------------------------------"
echo "Copy option executing with $MOD parameter..."

sudo cp $MOD assets_installer/bitfranc_replace/modaloverlay.ui ~/bitcoin/src/qt/forms/
sudo cp $MOD assets_installer/bitfranc_replace/overviewpage.ui ~/bitcoin/src/qt/forms/
sudo cp $MOD assets_installer/bitfranc_replace/guiutil.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/update-translations.py ~/bitcoin/contrib/devtools/
sudo cp $MOD assets_installer/bitfranc_replace/bitcoin-cli.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/bitcoind.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/init.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/key.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/net.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/util.h ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/validation.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/addressbookpage.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/askpassphrasedialog.cpp ~/bitcoin/src/qt/forms/
sudo cp $MOD assets_installer/bitfranc_replace/bitcoin.cpp ~/bitcoin/src/qt/
sudo cp	$MOD assets_installer/bitfranc_replace/bitcoingui.cpp ~/bitcoin/src/qt/
sudo cp	$MOD assets_installer/bitfranc_replace/blockchain.cpp ~/bitcoin/src/rpc/
sudo cp	$MOD assets_installer/bitfranc_replace/db.cpp ~/bitcoin/src/wallet/
sudo cp	$MOD assets_installer/bitfranc_replace/editaddressdialog.cpp ~/bitcoin/src/qt/
sudo cp	$MOD assets_installer/bitfranc_replace/feature_help.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/interface_bitcoin_cli.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/interface_rest.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/intro.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/mempool_persist.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/mining.cpp ~/bitcoin/src/rpc/
sudo cp $MOD assets_installer/bitfranc_replace/mininode.py ~/bitcoin/test/functional/test_framework/
sudo cp $MOD assets_installer/bitfranc_replace/misc.cpp ~/bitcoin/src/rpc/
sudo cp $MOD assets_installer/bitfranc_replace/net2.cpp ~/bitcoin/src/rpc/
sudo mv ~/bitcoin/test/functional/net2.cpp ~/bitcoin/src/rpc/net.cpp
sudo cp $MOD assets_installer/bitfranc_replace/openuridialog.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/paymentserver.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/rawtransaction.cpp ~/bitcoin/src/rpc/
sudo cp $MOD assets_installer/bitfranc_replace/rpcdump.cpp ~/bitcoin/src/wallet/
sudo cp $MOD assets_installer/bitfranc_replace/rpc_fundrawtransaction.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/rpc_rawtransaction.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/rpcwallet.cpp ~/bitcoin/src/wallet/
sudo cp $MOD assets_installer/bitfranc_replace/sendcoinsdialog.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/server.cpp ~/bitcoin/src/rpc/
sudo cp $MOD assets_installer/bitfranc_replace/test_runner.py ~/bitcoin/test/functional/
sudo cp $MOD assets_installer/bitfranc_replace/utilitydialog.cpp ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitfranc_replace/wallettests.cpp ~/bitcoin/src/qt/test/
sudo cp $MOD assets_installer/bitfranc_replace/wallet_tests.cpp ~/bitcoin/src/wallet/test/
sudo cp $MOD assets_installer/bitfranc_replace/amount.h ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/chainparams.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/chainparamsbase.cpp ~/bitcoin/src/
sudo cp $MOD assets_installer/bitfranc_replace/pow.cpp ~/bitcoin/src/

sudo rm -rf ~/bitcoin/src/qt/locale
sudo cp $MOD -R assets_installer/locale ~/bitcoin/src/qt/
sudo cp $MOD assets_installer/bitcoin.png ~/bitcoin/src/qt/res/icons/bitcoin.png
sudo cp $MOD assets_installer/bitcoin.ico ~/bitcoin/src/qt/res/icons/bitcoin.ico

if [ $INSTALL="yes" ]; then
    echo "--------------------------------------------------"
    echo "Install and configure DB4..."

    sudo mkdir ~/bitcoin/db4/
    cd ~/bitcoin/db4
    sudo wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz
    sudo tar -xzvf db-4.8.30.NC.tar.gz
    sudo rm -rf db-4.8.30.NC.tar.gz
    DB4_PATH=$PWD
    cd db-4.8.30.NC/build_unix
    sudo ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$DB4_PATH
    sudo make install
fi

cd ~/bitcoin
if [ $OS = "win"]; then
    cd ~/bitcoin/depends
    CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site
    sudo update-alternatives --set x86_64-w64-mingw32-g++ /usr/bin/x86_64-w64-mingw32-g++-posix
    sudo make HOST=x86_64-w64-mingw32
fi

if [ $INSTALL = "yes" ]; then
    sudo ./autogen.sh
    sudo ./configure LDFLAGS="-L$DB4_PATH/lib/" CPPFLAGS="-I$DB4_PATH/include/"
    sudo sed -i -e 's/bitcoin/bitFranc/g' ~/bitcoin/src/config/bitcoin-config.h
    sudo sed -i -e 's/Bitcoin/BitFranc/g' ~/bitcoin/src/config/bitcoin-config.h
    sudo sed -i -e 's/BITCOIN/BITFRANC/g' ~/bitcoin/src/config/bitcoin-config.h
    sudo sed -i -e 's/bitcoins/bitFrancs/g' ~/bitcoin/src/config/bitcoin-config.h
    sudo sed -i -e 's/Bitcoins/BitFrancs/g' ~/bitcoin/src/config/bitcoin-config.h
    sudo sed -i -e 's/BITCOINS/BITFRANCS/g' ~/bitcoin/src/config/bitcoin-config.h
fi

sudo make

sudo mv ~/bitcoin/src/bitcoind ~/bitcoin/src/bitfrancd
sudo mv	~/bitcoin/src/bitcoin-tx ~/bitcoin/src/bitfranc-tx
sudo mv	~/bitcoin/src/bitcoin-cli ~/bitcoin/src/bitfranc-cli
sudo mv	~/bitcoin/src/qt/bitcoin-qt ~/bitcoin/src/qt/bitfranc-qt

if [ $NOEXEC = "no" ]; then
    ~/bitcoin/src/qt/./bitfranc-qt
fi
exit;