#!/bin/bash

check_last_command_success() {
    if [ $? -ne 0 ]; then
        echo "$1"
        exit 1
    fi
}

export REPO=$(mktemp /tmp/repo.XXXXXXXXX)
curl -o ${REPO} https://storage.googleapis.com/git-repo-downloads/repo
check_last_command_success "Failed to download the repo tool."

gpg --recv-key 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
check_last_command_success "Failed to receive GPG key."

curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc | gpg --verify - ${REPO} && install -m 755 ${REPO} ~/bin/repo
check_last_command_success "Failed to verify and install the repo tool."

python3 ~/bin/repo init -u https://github.com/flywithu/manifest -b master -m aosp11.xml
check_last_command_success "Failed to initialize the repo."

python3 ~/bin/repo forall -c 'git reset --hard && git clean -xfd'
check_last_command_success "Failed to repo reset."

python3 ~/bin/repo sync -j 1 --fail-fast
check_last_command_success "Failed to sync the repositories."

python3 ~/bin/repo forall -c git lfs pull
check_last_command_success "Failed to pull Git LFS files."

docker build -t flywithu:aosp11 -f docker/Dockerfile_emu86_extract docker
check_last_command_success "Failed to build Docker."

docker run --rm -it -v $(pwd):/home/aosp flywithu:aosp11 /bin/bash -c 'source vendor/google/emu-x86/update.sh x86_64'
check_last_command_success "Failed to execute extract."


docker run --rm -it -v $(pwd):/home/aosp flywithu:aosp11 /bin/bash -c 'python3 docker/diff_to_patch.py docker/mydiff.patch'
check_last_command_success "Failed to execute extract."
