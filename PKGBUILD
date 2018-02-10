developer="http://upon2020.com/"
url="http://github.com/jernst/milight/"
maintainer=$developer
pkgname=$(basename $(pwd))
pkgver=0.1
pkgrel=1
pkgdesc="Script milight LED lights"
arch=('any')
license=('AGPL3')
options=('!strip')

package() {
# Code
    mkdir -p ${pkgdir}/usr/bin
    install -m755 ${startdir}/milight -t ${pkgdir}/usr/bin/
}

