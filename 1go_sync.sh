#!/bin/bash

export REPO=$(mktemp /tmp/repo.XXXXXXXXX)
curl -o ${REPO} https://storage.googleapis.com/git-repo-downloads/repo
gpg --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - ${REPO} && install -m 755 ${REPO} ~/bin/repo

python3 ~/bin/repo init -u https://github.com/flywithu/manifest -b master -m aosp9.xml
python3 ~/bin/repo sync -j 2
python3 ~/bin/repo forall -c git lfs pull
curl https://github.com/cwhuang/aosp_build/commit/384cdac7930e7a2b67fd287cfae943fdaf7e5ca3.patch | git -C vendor/opengapps/build apply -v --index
curl https://github.com/cwhuang/aosp_build/commit/3bb6f0804fe5d516b6b0bc68d8a45a2e57f147d5.patch | git -C vendor/opengapps/build apply -v --index
