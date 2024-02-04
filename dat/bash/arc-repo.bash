#!/bin/bash

## arc-repo.bash ::
# Custom package repository maintenance tool for Arch Linux.
# [old]

arc_repo_help() {
cat <<'HELPDOC'
NAME
    arc-repo

SYNOPSIS
    arc-repo <OPERATION> [OPTIONS] [TARGETS]

DESCRIPTION
    arc-repo is a custom package repository maintenance tool for
    use with Arch Linux (x86_64).

OPERATIONS
    -B, --build
        Build package in clean chroot.  This operation builds and
        signs the package in the current directory.

    -D, --database
        Operate on package database and pkgbuild files.  This
        operation is used to add, remove, refresh, and/or sign
        custom packages.

    -G, --git
        Push/pull from remote git repository.

    -Q, --query
        Query repo packages.  This operation allows you to view and
        check current repo packages for upstream updates, list
        installed packages, and show individual package information.

    -H, --help
        Display this help.

OPTIONS
    --repo <PATH>
        Path to custom package repository database file.

    -s, --sign
        Sign newly built packages, database updates, and git commits.

    --no-sign
        Do not sign.

    --gpg-key <GPG_KEY_ID>
        GPG signing key to override default user key.

    -q, --quiet
        Show less information.

    -v, --verbose
        Show more information.

    --color
        Display colored output.

    --no-color
        Do not color output.

BUILD OPTIONS (apply to -B)
    -a, --add
        Add newly built package to repo.

DATABASE OPTIONS (apply to -D)
    -a, --add
        Add package from current directory to custom repo.

    -r, --remove <PACKAGES>
        Remove packages from repo and delete any PKGBUILD files.

    -u, --update
        Refresh all packages and signatures.

GIT OPTIONS (apply to -G)
    -c, --commit
        Commit changes to local git repository.

    -m, --message <MESSAGE>
        Commit message.

    -p, --push
        Commit and push changes to remote git repository.

    -u, --pull
        Pull from remote git repository.

QUERY OPTIONS (apply to -Q)
    -i, --info
        Display information on a given package.

    -l, --list
        List all files owned by a given package.

    -u, --upstream
        Check current upstream release versions.

REQUIREMENTS
    devtools
        Used to simplify building in a clean chroot.

    gnupg
        Used to sign packages and repo with user's default private key.

ENVIRONMENT VARIABLES
    ARC_REPO
        This variable is used to set the custom repository database.
HELPDOC
return 0
}

##===========================  VARIABLES  ============================##
DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# args control:
ARGS=( "$@" )
ARGS_N=0
ARG="${ARGS[ARGS_N]}"
FLAG_ARG_EMPTY='false'
FLAG_ARG_HELP='false'
FLAG_ARG_UNKNOWN='false'
# operation args:
FLAG_BUILD='false'
FLAG_DATABASE='false'
FLAG_GIT='false'
FLAG_QUERY='false'
OPERATIONS_COUNT=0
# flag args:
FLAG_ADD='false'
FLAG_CLEAN='false'
FLAG_COLOR='true'
FLAG_COMMIT='false'
FLAG_INFO='false'
FLAG_LIST='false'
FLAG_PULL='false'
FLAG_PUSH='false'
FLAG_QUIET='false'
FLAG_REMOVE='false'
FLAG_SIGN='false'
FLAG_UPDATE='false'
FLAG_UPSTREAM='false'
FLAG_VERBOSE='false'
FLAG_VERBOSE2='false'
# option args:
ARG_MESSAGE=
ARG_GPG_KEY=
ARG_REPO=
# target args:
TARGETS=()
TARGETS_COUNT=0
# repository:
REPO_PKGS=()
REPO_PKG_NAMES=()
REPO_PKG_VERSIONS=()
REPO_PKGS_COUNT=0
REPO_DB=
REPO_NAME=
REPO_DIR=
REPO_CACHE_DIR=
REPO_PKGBUILD_DIR=
TEMP_BUILD_DIR='/tmp/arc-build'
ARCHBUILD_DIR='/var/lib/archbuild/extra-x86_64'
# control:
GPG_USER_ARG=''
# colors:
COLOR_BLUE='\e[0;38;5;27m'
COLOR_BLUE_B='\e[1;38;5;27m'
COLOR_CYAN='\e[0;38;5;14m'
COLOR_CYAN_B='\e[1;36m'
COLOR_GREEN='\e[0;38;5;46m'
COLOR_GREEN_B='\e[1;38;5;46m'
COLOR_RED='\e[0;38;5;196m'
COLOR_RED_B='\e[1;38;5;196m'
COLOR_YELLOW='\e[0;38;5;11m'
COLOR_YELLOW_B='\e[1;33m'
COLOR_WHITE='\e[0;38;5;15m'
COLOR_WHITE_B='\e[1;37m'
COLOR_GRAY='\e[0;37m'

##===========================  FUNCTIONS  ============================##
color_set() {
    if [ "$FLAG_COLOR" = 'false' ]; then
        unset COLOR_BLUE COLOR_BLUE_B COLOR_CYAN COLOR_CYAN_B \
            COLOR_GREEN COLOR_GREEN_B COLOR_RED COLOR_RED_B \
            COLOR_YELLOW COLOR_YELLOW_B COLOR_WHITE COLOR_WHITE_B \
            COLOR_GRAY
    fi
    return 0
}

msg() {
    if [ "$FLAG_QUIET" != 'true' ]; then
        local MSG="$1"; shift
        printf "$COLOR_GREEN_B==>$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    fi
    return 0
}
msg_ask() {
    local MSG="$1"; shift
    printf "$COLOR_BLUE_B::$COLOR_WHITE_B $MSG$COLOR_GRAY " "$@"
    return 0
}
msg_error() {
    local MSG="$1"; shift
    printf "$COLOR_RED_B==> ERROR:$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg_error2() {
    local MSG="$1"; shift
    printf "${COLOR_RED_B}error:$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg_warn() {
    local MSG="$1"; shift
    printf "$COLOR_YELLOW_B==> WARNING:"
    printf "$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg_warn2() {
    local MSG="$1"; shift
    printf "${COLOR_YELLOW_B}warning:"
    printf "$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg_plain() {
    if [ "$FLAG_QUIET" != 'true' ]; then
        local MSG="$1"; shift
        printf "$COLOR_WHITE_B    $MSG$COLOR_GRAY\n" "$@"
    fi
    return 0
}

msg2() {
    if [ "$FLAG_QUIET" != 'true' ]; then
        local MSG="$1"; shift
        printf "$COLOR_BLUE_B  ->$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    fi
    return 0
}
msg2_error() {
    local MSG="$1"; shift
    printf "$COLOR_RED_B  ->$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg2_warn() {
    local MSG="$1"; shift
    printf "$COLOR_YELLOW_B  ->$COLOR_WHITE_B $MSG$COLOR_GRAY\n" "$@"
    return 0
}
msg2_plain() {
    if [ "$FLAG_QUIET" != 'true' ]; then
        local MSG="$1"; shift
        printf "$COLOR_WHITE_B     $MSG$COLOR_GRAY\n" "$@"
    fi
    return 0
}

internet_check() {
    return $(ping -q -c1 -W3 google.com &>/dev/null ||
        ping -q -c1 -W5 archlinux.org &>/dev/null)
}

##========================  arc_repo_add  ========================##
# Add package $PKGNAME to custom repo.
arc_repo_add() {
    #global REPO_DB REPO_DIR REPO_NAME REPO_PKGBUILD_DIR
    #arc_repo_build/database PKG_FILES PKGNAME PKGREL PKGVER
    msg "Adding %s to %s..." "$PKGNAME" "$REPO_NAME"
    repo-add "$REPO_DB" *.pkg.tar.xz
    rm -f "$REPO_DIR"/*.old "$REPO_DIR"/*.old.sig
    # backup old build files in cache:
    arc_repo_cache
    rm -rf "$REPO_PKGBUILD_DIR/$PKGNAME"
    mkdir -p "$REPO_PKGBUILD_DIR/$PKGNAME"
    cp "${PKG_FILES[@]}" "$REPO_PKGBUILD_DIR/$PKGNAME"
    # mv package files to repo directory:
    rm -f "$REPO_DIR/$PKGNAME-"[0-9]*
    mv *.pkg.tar.xz* "$REPO_DIR"
    # sign repo:
    arc_repo_sign
    # update README.rst:
    arc_repo_readme_update
    return 0
}

##=======================  arc_repo_build  =======================##
# Build Arch Linux package from PKGBUILD in current directory.
arc_repo_build() {
    #global REPO_CACHE_DIR REPO_DIR FLAG_ADD TEMP_BUILD_DIR
    local CACHE_DIR MAKECHROOTPKG_ARGS PKG_DEPS PKG_FILES \
        PKGNAME PKGREL PKGVER
    # FAIL: no PKGBUILD or .SRCINFO in current directory:
    if [ ! -f PKGBUILD ] || [ ! -f .SRCINFO ]; then
        msg_error2 'no PKGBUILD and/or .SRCINFO in current directory'
        return 3
    fi
    # get package information:
    arc_repo_pkgbuild_parse
    msg "Building $PKGNAME-$PKGVER-$PKGREL..."
    # copy files to build directory:
    rm -rf "$TEMP_BUILD_DIR/$PKGNAME"
    mkdir -p "$TEMP_BUILD_DIR/$PKGNAME"
    cp "${PKG_FILES[@]}" "$TEMP_BUILD_DIR/$PKGNAME"
    cd "$TEMP_BUILD_DIR/$PKGNAME"
    # extra-x86-build:
    msg2 "extra-x86_64-build..."
    extra-x86_64-build -- ${MAKECHROOTPKG_ARGS[*]}
    # FAIL: building package failed:
    if [ $? -ne 0 ]; then
        msg_error "Building package %s failed." "$PKGNAME"
        msg2_warn "source files: %s" "$TEMP_BUILD_DIR/$PKGNAME/"
        if [ -d "$ARCHBUILD_DIR/$USER/build/$PKGNAME" ]; then
            msg2_warn "build files: %s" \
                "$ARCHBUILD_DIR/$USER/build/$PKGNAME/"
        fi
        return 3
    else
        msg "Building %s complete." "$PKGNAME"
        # copy files to cache directory:
        CACHE_DIR="$REPO_CACHE_DIR/$PKGNAME-$PKGVER-$PKGREL"
        if [ -d "$CACHE_DIR" ]; then
            N=2
            while [ -d "${CACHE_DIR}_${N}" ]; do
                ((N++))
            done
            CACHE_DIR+="_${N}"
        fi
        mkdir "$CACHE_DIR"
        cp "${PKG_FILES[@]}" "$CACHE_DIR"
        cp *.pkg.tar.xz "$CACHE_DIR"
        cd "$CACHE_DIR"
        # sign package files:
        arc_repo_package_sign
        # add package to repo:
        msg2 "source files: %s" "$TEMP_BUILD_DIR/$PKGNAME/"
        if [ -d "$ARCHBUILD_DIR/$USER/build/$PKGNAME" ]; then
            msg2 "build files: %s" \
                "$ARCHBUILD_DIR/$USER/build/$PKGNAME/"
        fi
        if [ "$FLAG_ADD" = 'true' ]; then
            arc_repo_add
        else
            msg2 "package files: $PWD/"
        fi
    fi
    return 0
}

##=======================  arc_repo_cache  =======================##
# Add previous package build files to cache.
arc_repo_cache() {
    #global REPO_CACHE_DIR REPO_PKGBUILD_DIR
    #arc_repo_add/database PKGNAME
    local CACHE_VER CACHE_REL CACHE_DIR N
    if [ -f "$REPO_PKGBUILD_DIR/$PKGNAME/PKGBUILD" ]; then
        CACHE_VER="$(. "$REPO_PKGBUILD_DIR/$PKGNAME/PKGBUILD"; \
            printf "$pkgver")"
        CACHE_REL="$(. "$REPO_PKGBUILD_DIR/$PKGNAME/PKGBUILD"; \
            printf "$pkgrel")"
        CACHE_DIR="$REPO_CACHE_DIR/$PKGNAME-$CACHE_VER-$CACHE_REL"
        if [ -d "$CACHE_DIR" ]; then
            N=2
            while [ -d "${CACHE_DIR}_${N}" ]; do
                ((N++))
            done
            CACHE_DIR+="_${N}"
        fi
        cp -r "$REPO_PKGBUILD_DIR/$PKGNAME" "$CACHE_DIR"
    fi
    return 0
}

##=====================  arc_repo_database  ======================##
# Perform repo database tasks (add, remove, update).
arc_repo_database() {
    #global FLAG_ADD FLAG_REMOVE FLAG_UPDATE REPO_DB REPO_DIR \
        #REPO_PKG_NAMES TARGETS TARGETS_COUNT
    local FLAG_FILE_ERROR FLAG_SIGN_ERROR PKG_DIR PKG_DIRS PKG_FILES \
        PKGNAME PKGREL PKGVER REMOVE_ERRORS REMOVE_TARGETS TAR TARGET
    FLAG_FILE_ERROR='false'
    FLAG_SIGN_ERROR='false'
    # FAIL: add and remove in same command:
    if [ "$FLAG_ADD" = 'true' ] && [ "$FLAG_REMOVE" = 'true' ]; then
        msg_error2 'cannot add and remove from repo in same command'
        return 1
    fi
    # add package to repo:
    if [ "$FLAG_ADD" = 'true' ]; then
        # FAIL: no PKGBUILD and/or .SRCINFO:
        if [ ! -f PKGBUILD ] || [ ! -f .SRCINFO ]; then
            msg_error2 'PKGBUILD and/or .SRCINFO not found'
            return 3
        fi
        # get package information:
        arc_repo_pkgbuild_parse
        # FAIL: package file missing:
        for FILE in "${PKG_FILES[@]}"; do
        if [ ! -f "$FILE" ]; then
            msg_error2 "$FILE not found"
            return 3
        fi; done
        # use files and package from current directory:
        if (ls *.pkg.tar.xz &>/dev/null); then
            PKG_DIR="$PWD"
            FLAG_FILE_ERROR='false'
        # check cache for file and package:
        else
            PKG_DIRS=($(find "$REPO_CACHE_DIR" -type d \
                -name *"$PKGNAME-$PKGVER-$PKGREL"* | sort -r))
            for PKG_DIR in "${PKG_DIRS[@]}"; do
                # check for package files:
                FLAG_FILE_ERROR='false'
                for FILE in "${PKG_FILES[@]}"; do
                    if [ ! -f "$PKG_DIR/$FILE" ]; then
                        FLAG_FILE_ERROR='true'
                        break
                    # check file diff with current directory:
                    elif ! (diff -q "$FILE" "$PKG_DIR/$FILE" \
                    &>/dev/null); then
                        FLAG_FILE_ERROR='true'
                        break
                    fi
                done
                # check for package:
                if ! (ls "$PKG_DIR" | \
                grep .pkg.tar.xz &>/dev/null); then
                    FLAG_FILE_ERROR='true'
                fi
                if [ "$FLAG_FILE_ERROR" = 'false' ]; then
                    break
                fi
            done
            if [ "$FLAG_FILE_ERROR" = 'false' ]; then
                cd "$PKG_DIR"
            fi
        fi
        # FAIL: package not found:
        if [ "$FLAG_FILE_ERROR" = 'true' ]; then
            msg2_error "package %s not found" "$PKGNAME"
            return 3
        fi
        # sign package files:
        arc_repo_package_sign
        # add package to repo:
        arc_repo_add
    # remove package from repo:
    elif [ "$FLAG_REMOVE" = 'true' ]; then
        # choose package from PKGBUILD in current directory:
        if [ $TARGETS_COUNT -eq 0 ] && [ -f PKGBUILD ]; then
            TARGETS+=("$(. PKGBUILD; printf "$pkgname")")
        fi
        # check if packages in repo:
        for TARGET in "${TARGETS[@]}"; do
            if [[ " ${REPO_PKG_NAMES[@]} " =~ " $TARGET " ]]; then
                REMOVE_TARGETS+=("$TARGET")
            else
                REMOVE_ERRORS+=("$TARGET")
            fi
        done
        # cache old build files:
        for PKGNAME in "${REMOVE_TARGETS[@]}"; do
            arc_repo_cache
            rm -rf "$REPO_PKGBUILD_DIR/$PKGNAME"
        done
        # remove packages from repo
        if [ -n "${REMOVE_TARGETS[0]}" ]; then
            msg "removing %s from %s..." "${REMOVE_TARGETS[*]}" \
                "$REPO_NAME"
            repo-remove -R "$REPO_DB" ${REMOVE_TARGETS[*]}
            rm -f "$REPO_DIR/$PKGNAME-"[0-9]*
            rm -f "$REPO_DIR"/*.old "$REPO_DIR"/*.old.sig
            # sign repo:
            arc_repo_sign
        fi
        # WARN: target packages not in repo:
        if [ -n "${REMOVE_ERRORS[0]}" ]; then
            msg_warn2 "packages %s not in %s" "${REMOVE_ERRORS[*]}" \
                "$REPO_NAME"
        fi
    fi
    # update repo:
    if [ "$FLAG_UPDATE" = 'true' ]; then
        cd "$REPO_DIR"
        # sign package files:
        arc_repo_package_sign
        # add packages to repo:
        msg 'Adding packages...'
        repo-add "$REPO_DB" *.pkg.tar.xz
        rm -f *.old *.old.sig
        # sign repo:
        arc_repo_sign
        # update README.rst:
        arc_repo_readme_update
    fi
    # print database info:
    if [ "$FLAG_ADD" = 'false' ] &&[ "$FLAG_REMOVE" = 'false' ] && \
    [ "$FLAG_UPDATE" = 'false' ]; then
        cd "$REPO_DIR"
        msg "%s" "$REPO_DB"
        msg2 "%d packages" "$REPO_PKGS_COUNT"
        # check signatures:
        if ! (gpg --verify "$REPO_DB.sig" "$REPO_DB" &>/dev/null); then
            FLAG_SIGN_ERROR='true'
        fi
        for TAR in *.pkg.tar.xz; do
        if ! (gpg --verify "$TAR.sig" "$TAR" &>/dev/null); then
            FLAG_SIGN_ERROR='true'
        fi; done
        if [ "$FLAG_SIGN_ERROR" = 'true' ]; then
            msg2_warn 'unsigned'
        else
            msg2 'signatures verified'
        fi
    fi
    return 0
}

##========================  arc_repo_git  ========================##
# Perform basic git repository remote syncing tasks.
arc_repo_git() {
    #global FLAG_COMMIT FLAG_PULL FLAG_PUSH FLAG_SIGN REPO_DB REPO_DIR
    local GIT_COMMIT_MESSAGE="arc-repo-$(date '+%F-%H:%M:%S')"
    # FAIL: custom repo is not in a git repository:
    if ! (git -C "$REPO_DIR" rev-parse --git-dir &>/dev/null); then
        msg_error2 "% not in a git repo" "$(basename "$REPO_DB")"
        return 2
    fi
    # WARN: no git operation given:
    if [ "$FLAG_COMMIT" = 'false' ] && [ "$FLAG_PULL" = 'false' ] && \
    [ "$FLAG_PUSH" = 'false' ]; then
        msg_warn2 'No git operation specified, nothing done'
        return 0
    fi
    # commit message:
    if [ -n "$ARG_MESSAGE" ]; then
        GIT_COMMIT_MESSAGE="$ARG_MESSAGE"
    fi
    # git pull:
    if [ "$FLAG_PULL" = 'true' ]; then
        msg 'Pulling from remote git repository...'
        git -C "$REPO_DIR" pull
        return $?
    fi
    # git commit:
    if [ "$FLAG_COMMIT" = 'true' ] || [ "$FLAG_PUSH" = 'true' ]; then
        msg 'Committing to local repository...'
        git -C "$REPO_DIR" add --all
        # sign commit
        if [ "$FLAG_SIGN" = 'true' ]; then
            msg 'Signing commit...'
            git -C "$REPO_DIR" commit -S -m "$GIT_COMMIT_MESSAGE"
        # commit:
        else
            git -C "$REPO_DIR" commit -m "$GIT_COMMIT_MESSAGE"
        fi
    fi
    # git push:
    if [ "$FLAG_PUSH" = 'true' ]; then
        msg 'Pushing to remote git repository...'
        git -C "$REPO_DIR" push origin master
        return $?
    fi
    return 0
}

##===================  arc_repo_package_sign  ====================##
# Sign package files in current directory.
arc_repo_package_sign() {
    #global FLAG_SIGN GPG_USER_ARG
    local TAR
    if [ "$FLAG_SIGN" = 'true' ]; then
        msg 'Signing package files...'
        for TAR in *.pkg.tar.xz; do
            rm -f "$TAR.sig"
            gpg -bq --use-agent $GPG_USER_ARG --no-armor "$TAR"
            msg2 "$TAR.sig"
        done
    fi
    return 0
}

##==================  arc_repo_pkgbuild_parse  ===================##
# Parse PKGBUILD in current directory for info and dependencies.
arc_repo_pkgbuild_parse() {
    #sets: MAKECHROOTPKG_ARGS PKG_DEPS PKG_FILES PKGNAME PKGREL PKGVER
    local DEP N
    # package name, version, rel:
    PKGNAME="$(. PKGBUILD; printf "$pkgbase")"
    if [ -z "$PKGNAME" ]; then
        PKGNAME="$(. PKGBUILD; printf "$pkgname")"
    fi
    PKGVER="$(. PKGBUILD; printf "$pkgver")"
    PKGREL="$(. PKGBUILD; printf "$pkgrel")"
    # package dependencies:
    PKG_DEPS=( $(. PKGBUILD; printf "${makedepends[*]} ${depends[*]}") )
    # package files:
    PKG_FILES=( PKGBUILD )
    if [ -f .SRCINFO ]; then
        PKG_FILES+=( .SRCINFO )
    fi
    PKG_FILES+=( $(. PKGBUILD; printf "%s\n" "${source[@]}" | \
        grep -Piv '(http|https|ftp|ftps)://') )
    if ! [[ "${PKG_FILES[*]}" =~ "$PKGNAME.install" ]]; then
        PKG_FILES+=( $(. PKGBUILD; printf "$install") )
    fi
    if ! [[ "${PKG_FILES[*]}" =~ "$PKGNAME.install" ]]; then
        PKG_FILES+=( $(grep -Pom1 \
            "install=\K$PKGNAME.install" PKGBUILD) )
    fi
    if ! [[ "${PKG_FILES[*]}" =~ "$PKGNAME.install" ]] &&
    [ -f "$PKGNAME.install" ]; then
        msg2_warn "$PKGNAME.install not included in PKGBUILD."
        PKG_FILES+=("$PKGNAME.install")
    fi
    # check for dependencies from repo:
    N=0
    DEP="${PKG_DEPS[N]}"
    while [ -n "$DEP" ]; do
        if [ -f "$REPO_DIR/$DEP-"[0-9]*.pkg.tar.xz ]; then
            # queue dependency for install in chroot build environment:
            MAKECHROOTPKG_ARGS=('-I'
                "$REPO_DIR/$DEP-"[0-9]*.pkg.tar.xz
                "${MAKECHROOTPKG_ARGS[*]}" )
            # check for additional dependencies from repo:
            PKG_DEPS+=( $(pacman -Qi -p \
                "$REPO_DIR/$DEP-"[0-9]*.pkg.tar.xz | \
                grep -Po 'Depends On\s*:\s\K.*' | tr " " "\n" | \
                grep -Po '^\K[^=<>]+' ) )
        fi
        ((N++))
        DEP="${PKG_DEPS[N]}"
    done
    return 0
}

##=======================  arc_repo_query  =======================##
# Print repository package information.
arc_repo_query() {
    #global FLAG_INFO FLAG_LIST FLAG_UPSTREAM FLAG_VERBOSE \
        #FLAG_VERBOSE2 REPO_DIR REPO_PKG_NAMES REPO_PKGS \
        #REPO_PKG_VERSIONS TARGETS TARGETS_COUNT
    local DESC N PKG QUERY_ERRORS QUERY_PKG_NAMES QUERY_PKGS \
        QUERY_PKG_VERSIONS TARGET URL VER
    # set query packages from TARGETS:
    if [ $TARGETS_COUNT -gt 0 ]; then
        for TARGET in "${TARGETS[@]}"; do
            # check for package in repo:
            if [[ " ${REPO_PKG_NAMES[*]} " =~ " $TARGET " ]]; then
                QUERY_PKG_NAMES+=("$TARGET")
                # get package version:
                for ((N=0;N<REPO_PKGS_COUNT;N++)); do
                    if [ "$TARGET" = "${REPO_PKG_NAMES[N]}" ]; then
                        QUERY_PKGS+=("${REPO_PKGS[N]}")
                        QUERY_PKG_VERSIONS+=(
                            "${REPO_PKG_VERSIONS[N]}")
                        break
                    fi
                done
            # package not in repo:
            else
                QUERY_ERRORS+=("$TARGET")
            fi
        done
    # set query to all packages in repo:
    else
        QUERY_PKGS=("${REPO_PKGS[@]}")
        QUERY_PKG_NAMES=("${REPO_PKG_NAMES[@]}")
        QUERY_PKG_VERSIONS=("${REPO_PKG_VERSIONS[@]}")
    fi
    # check upstream versions:
    if [ "$FLAG_UPSTREAM" = 'true' ]; then
        arc_repo_query_upstream
    # get package info:
    elif [ "$FLAG_INFO" = 'true' ] || [ "$FLAG_LIST" = 'true' ] ; then
        arc_repo_query_info_list
    # print query packages:
    else
        N=0
        while [ -n "${QUERY_PKG_NAMES[N]}" ]; do
            # verbose info:
            if [ "$FLAG_VERBOSE" = 'true' ]; then
                PKG="${QUERY_PKG_NAMES[N]}"
                VER="${QUERY_PKG_VERSIONS[N]}"
                msg2 "%s $COLOR_GREEN_B%s" "$PKG" "$VER"
                DESC="$(pacman -Qi -p \
                    "$REPO_DIR/${PKG}-"[0-9]*.pkg.tar.xz | \
                    grep -Pom1 '\s*Description\s*:\s*\K.*')"
                msg2_plain "$COLOR_BLUE%s" "$DESC"
                if [ "$FLAG_VERBOSE2" = 'true' ]; then
                    URL="$(pacman -Qi -p \
                        "$REPO_DIR/${PKG}-"[0-9]*.pkg.tar.xz | \
                        grep -Pom1 '\s*URL\s*:\s*\K.*')"
                    msg2_plain "$COLOR_CYAN%s" "$URL"
                fi
            else
                printf "$COLOR_WHITE_B${QUERY_PKG_NAMES[N]}"
                if [ "$FLAG_QUIET" = 'false' ]; then
                    printf " $COLOR_GREEN_B${QUERY_PKG_VERSIONS[N]}"
                fi
                printf "$COLOR_GRAY\n"
            fi
            ((N++))
        done
    fi
    # WARN: queried packages not in repo:
    if [ -n "${QUERY_ERRORS[0]}" ]; then
        msg_warn2 "packages %s not in %s" "${QUERY_ERRORS[*]}" \
            "$REPO_NAME"
    fi
    return 0
}

##==================  arc_repo_query_info_list  ==================##
# Print verbose repository package information.
arc_repo_query_info_list() {
    #global FLAG_COLOR FLAG_INFO FLAG_LIST REPO_DIR
    #arc_repo_query QUERY_PKG_NAMES
    local PACMAN_ARGS PKG_NAME
    PACMAN_ARGS=('-Q')
    # set pacman args:
    if [ "$FLAG_INFO" = 'true' ]; then
        PACMAN_ARGS+=('-i')
    fi
    if [ "$FLAG_LIST" = 'true' ]; then
        PACMAN_ARGS+=('-l')
    fi
    if [ "$FLAG_COLOR" = 'false' ]; then
        PACMAN_ARGS+=(' --color' 'never')
    fi
    # query package info:
    for PKG_NAME in "${QUERY_PKG_NAMES[@]}"; do
        if (pacman -Q "$PKG_NAME" &>/dev/null); then
            pacman ${PACMAN_ARGS[@]} "$PKG_NAME"
        else
            pacman ${PACMAN_ARGS[@]} \
                -p "$REPO_DIR/$PKG_NAME-"[0-9]*.pkg.tar.xz
        fi
        if [ "$FLAG_LIST" = 'true' ]; then
            printf "\n"
        fi
    done
    return 0
}

##==================  arc_repo_query_upstream  ===================##
# Check, compare, print latest upstream package versions.
arc_repo_query_upstream() {
    #global FLAG_VERBOSE FLAG_VERBOSE2 REPO_DB REPO_PKGBUILD_DIR \
        #TEMP_BUILD_DIR
    #arc_repo_query QUERY_PKGS QUERY_PKG_NAMES QUERY_PKG_VERSIONS
    local AUR_URL AUR_VERSION BEHIND_COUNT GITHUB_URL GITHUB_VERSION \
        N PKG_BASE PKG_NAME PKG_URL PKG_VERSION PKG_VERSION_UPSTREAM \
        REGEX SRCINFO_URL UPSTREAM_VERSION URL_BASE_AUR
    REGEX='^\s*source\s*=\s*.*?\Khttps://github.com/[^/]+/[^/#]+'
    URL_BASE_AUR='https://aur.archlinux.org/cgit/aur.git'
    msg 'Checking upstream packages...'
    # FAIL: no internet connection:
    if ! (internet_check); then
        msg_error2 "no internet connection"
        return 4
    fi
    # extract repo database to build directory:
    if [ -d "$TEMP_BUILD_DIR/$REPO_NAME" ]; then
        rm -rfd "$TEMP_BUILD_DIR/$REPO_NAME"
    fi
    mkdir -p "$TEMP_BUILD_DIR/$REPO_NAME"
    tar -C "$TEMP_BUILD_DIR/$REPO_NAME" -xf "$REPO_DB"
    # query packages:
    N=0
    BEHIND_COUNT=0
    while [ -n "${QUERY_PKG_NAMES[N]}" ]; do
        unset AUR_URL AUR_VERSION GITHUB_URL GITHUB_VERSION \
            SRCINFO_URL UPSTREAM_URL UPSTREAM_VERSION
        # get package info from database:
        PKG_NAME="${QUERY_PKG_NAMES[N]}"
        PKG_VERSION="${QUERY_PKG_VERSIONS[N]}"
        PKG_VERSION="${PKG_VERSION%%-*}"
        PKG_BASE=$(sed -n '/%BASE%/{n;p}' \
            "$TEMP_BUILD_DIR/$REPO_NAME/${QUERY_PKGS[N]}/desc")
        PKG_URL="$(sed -n '/%URL%/{n;p}' \
            "$TEMP_BUILD_DIR/$REPO_NAME/${QUERY_PKGS[N]}/desc")"
        # get git url from .SRCINFO:
        if [ -f "$REPO_PKGBUILD_DIR/$PKG_BASE/.SRCINFO" ]; then
            SRCINFO_URL="$(grep -Po "$REGEX" \
                "$REPO_PKGBUILD_DIR/$PKG_BASE/.SRCINFO")"
        fi
        # set github url:
        if [[ "$PKG_URL" =~ .*//github.com/.* ]]; then
            GITHUB_URL="$PKG_URL"
        elif [[ "$SRCINFO_URL" =~ .*//github.com/.* ]]; then
            GITHUB_URL="$SRCINFO_URL"
        fi
        # check for get github package version:
        if [ -n "$GITHUB_URL" ]; then
            # get github package version from releases/latest:
            GITHUB_VERSION=$(curl -s "$GITHUB_URL/releases/latest" | \
                grep -Po 'tag/v?\.?\K[^-"]+')
            # get github package version from releases:
            if [ -z "$GITHUB_VERSION" ]; then
                GITHUB_VERSION=$(curl -s "$GITHUB_URL/releases" |\
                    grep -Pom1 'releases/tag/v?\.?\K[^-"]+')
            fi
        fi
        # check for AUR package version:
        if [ -z "$GITHUB_VERSION" ]; then
            AUR_VERSION=$(curl -s \
                "$URL_BASE_AUR/plain/PKGBUILD?h=$PKG_BASE" | \
                grep -Po "^\s*pkgver=(\"|')?\K[^\s\"']+")
            if [ -n "$AUR_VERSION" ]; then
                AUR_URL="https://aur.archlinux.org/packages/$PKG_BASE/"
            fi
        fi
        # WARN: unable to check upstream package version:
        if [ -z "$GITHUB_VERSION" ] && [ -z "$AUR_VERSION" ]; then
            msg2_warn "unable to check \'$PKG_NAME\' upstream version"
        else
            # set upstream version and url:
            if [ -n "$GITHUB_VERSION" ]; then
                UPSTREAM_VERSION="$GITHUB_VERSION"
                UPSTREAM_URL="$GITHUB_URL"
            elif [ -n "$AUR_VERSION" ]; then
                UPSTREAM_VERSION="$AUR_VERSION"
                UPSTREAM_URL="$AUR_URL"
            fi
            # WARN: new upstream version
            if [ "$PKG_VERSION" != "$UPSTREAM_VERSION" ]; then
                msg2_warn "%s $COLOR_YELLOW_B%s -> $COLOR_GREEN_B%s" \
                    "$PKG_NAME" "$PKG_VERSION" "$UPSTREAM_VERSION"
                if [ "$FLAG_VERBOSE" = 'true' ]; then
                    msg2_plain "$COLOR_CYAN_B$UPSTREAM_URL"
                fi
                ((BEHIND_COUNT++))
            # repo package version up to date:
            elif [ "$FLAG_VERBOSE2" = 'true' ]; then
                msg2 "%s $COLOR_GREEN_B%s == $COLOR_GREEN_B%s" \
                    "$PKG_NAME" "$PKG_VERSION" "$UPSTREAM_VERSION"
                msg2_plain "$COLOR_CYAN%s" "$UPSTREAM_URL"
            fi
        fi
        ((N++))
    done
    if [ $BEHIND_COUNT -gt 0 ]; then
        msg_warn "%d packages behind upstream release." $BEHIND_COUNT
        return 4
    fi
    msg "All packages current with upstream."
    return 0
}

##======================  arc_repo_refresh  ======================##
# Refresh repo package information.
arc_repo_refresh() {
    #global REPO_DB REPO_PKGS REPO_PKGS_COUNT REPO_PKG_VERSIONS
    local PKG PKG_NAME PKG_VERSION
    REPO_PKGS=( $(tar -tf "$REPO_DB" | grep -Po '^\K[^/]+(?=/$)') )
    REPO_PKGS_COUNT=${#REPO_PKGS[@]}
    for PKG in "${REPO_PKGS[@]}"; do
        PKG_NAME="$(grep -Po '^\K.*?(?=\-[0-9\.])' <<< "$PKG")"
        REPO_PKG_NAMES+=( "$PKG_NAME" )
        PKG_VERSION="${PKG##$PKG_NAME-}"
        REPO_PKG_VERSIONS+=( "$PKG_VERSION" )
    done
    return 0
}

##=======================  arc_repo_sign  ========================##
# Sign custom package repo.
arc_repo_sign() {
    #global FLAG_SIGN GPG_USER_ARG REPO_DB REPO_DIR REPO_NAME
    if [ "$FLAG_SIGN" = 'true' ]; then
        msg "Signing %s..." "$REPO_NAME"
        rm -f "$REPO_DB.sig" "$REPO_DIR/$REPO_NAME.files.tar.gz.sig"
        gpg -bq --use-agent $GPG_USER_ARG --no-armor "$REPO_DB"
        gpg -bq --use-agent $GPG_USER_ARG --no-armor \
            "$REPO_DIR/$REPO_NAME.files.tar.gz"
        ln -sf "$REPO_DB.sig" "$REPO_DIR/$REPO_NAME.db.sig"
        ln -sf "$REPO_DIR/$REPO_NAME.files.tar.gz.sig" \
            "$REPO_DIR/$REPO_NAME.files.sig"
    fi
    return 0
}

##===================  arc_repo_readme_update  ===================##
# Update README.rst file.
arc_repo_readme_update() {
    #global REPO_DIR REPO_PKG_NAMES REPO_PKG_VERSIONS TEMP_BUILD_DIR
    local N PKG_NAME PKG_VERSION
    if [ -f "$REPO_DIR/README.rst" ]; then
        # refresh repo package information:
        msg 'Updating README.rst...'
        arc_repo_refresh
        mkdir -p "$TEMP_BUILD_DIR"
        cp "$REPO_DIR/README.rst" "$TEMP_BUILD_DIR/README.rst"
        N=0
        while [ -n "${REPO_PKG_NAMES[N]}" ]; do
            PKG_NAME="${REPO_PKG_NAMES[N]}"
            PKG_VERSION="${REPO_PKG_VERSIONS[N]}"
            sed -i "s/${PKG_NAME}_ .*/${PKG_NAME}_ ${PKG_VERSION}/g" \
                "$TEMP_BUILD_DIR/README.rst"
            ((N++))
        done
        cp "$TEMP_BUILD_DIR/README.rst" "$REPO_DIR/README.rst"
    fi
    return 0
}

##===========================  PARSE-ARGS  ===========================##
while [ -n "$ARG" ]; do case "$ARG" in
    # operation args:
    -B|--build)
        FLAG_BUILD='true'
        ARG="${ARGS[((++ARGS_N))]}"
        ((OPERATIONS_COUNT++)) ;;
    -D|--database)
        FLAG_DATABASE='true'
        ARG="${ARGS[((++ARGS_N))]}"
        ((OPERATIONS_COUNT++)) ;;
    -G|--git)
        FLAG_GIT='true'
        ARG="${ARGS[((++ARGS_N))]}"
        ((OPERATIONS_COUNT++)) ;;
    -Q|--query)
        FLAG_QUERY='true'
        ARG="${ARGS[((++ARGS_N))]}"
        ((OPERATIONS_COUNT++)) ;;
    # flag args:
    -a|--add)
        FLAG_ADD='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -c)
        FLAG_CLEAN='true'
        FLAG_COMMIT='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --clean)
        FLAG_CLEAN='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --commit)
        FLAG_COMMIT='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -i|--info)
        FLAG_INFO='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -l|--list)
        FLAG_LIST='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -p|--push)
        FLAG_PUSH='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -q|--quiet)
        FLAG_QUIET='true'
        FLAG_COLOR='false'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -r|--remove)
        FLAG_REMOVE='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -s|--sign)
        FLAG_SIGN='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -u)
        FLAG_PULL='true'
        FLAG_UPDATE='true'
        FLAG_UPSTREAM='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --pull)
        FLAG_PULL='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --update)
        FLAG_UPDATE='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --upstream)
        FLAG_UPSTREAM='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    -v|--verbose)
        if [ "$FLAG_VERBOSE" = 'true' ]; then
            FLAG_VERBOSE2='true'
        fi
        FLAG_VERBOSE='true'
        FLAG_QUIET='false'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --no-sign|--nosign)
        FLAG_SIGN='false'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --color)
        FLAG_COLOR='true'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    --no-color|--nocolor)
        FLAG_COLOR='false'
        ARG="${ARGS[((++ARGS_N))]}" ;;
    # option args:
    -m|--message)
        ARG_MESSAGE="${ARGS[((++ARGS_N))]}"
        if [ -z "${ARGS[ARGS_N]}" ]; then
            FLAG_ARG_EMPTY='true'
            break
        fi
        ARG="${ARGS[((++ARGS_N))]}"
        ((ARGS_COUNT++)) ;;
    --gpg-key)
        ARG_GPG_KEY="${ARGS[((++ARGS_N))]}"
        if [ -z "${ARGS[ARGS_N]}" ]; then
            FLAG_ARG_EMPTY='true'
            break
        fi
        ARG="${ARGS[((++ARGS_N))]}"
        ((ARGS_COUNT++)) ;;
    --repo)
        ARG_REPO="${ARGS[((++ARGS_N))]}"
        if [ -z "${ARGS[ARGS_N]}" ]; then
            FLAG_ARG_EMPTY='true'
            break
        fi
        ARG="${ARGS[((++ARGS_N))]}"
        ((ARGS_COUNT++)) ;;
    # set help flag:
    -H|--help|-h)
        FLAG_ARG_HELP='true'
        break ;;
    # all flag args:
    -[BDGQabcilpqrsuvHh]* )
        # all args:
        if [[ "${ARG:2:1}" =~ [BDGQabcilmpqrsuvHh] ]]; then
            ARGS[((ARGS_N--))]="-${ARG:2}"
            ARG="${ARG:0:2}"
        else
            ARG="${ARG:2:1}"
            FLAG_ARG_UNKNOWN='true'
            break
        fi ;;
    # all option args:
    -[m]*)
        ARGS[$ARGS_N]="${ARG:2}"
        ARG="${ARG:0:2}"
        ((ARGS_N--)) ;;
    # begin parms:
    --)
        ((ARGS_N++))
        break ;;
    *)
        break ;;
esac; done
# get targets:
while [ -n "${ARGS[ARGS_N]}" ]; do
    TARGETS+=("${ARGS[((ARGS_N++))]}")
done
TARGETS_COUNT=${#TARGETS[@]}
# set verbosity:
if [ "$FLAG_VERBOSE" = 'true' ]; then
    FLAG_QUIET='false'
fi
# set colors:
color_set
# HELP: no args or operations:
if [ "$FLAG_ARG_HELP" = 'true' ] || \
[ -z "$1" ] || [ $OPERATIONS_COUNT -eq 0 ]; then
    arc_repo_help
    exit 0
# FAIL: arg unknown:
elif [ "$FLAG_ARG_UNKNOWN" = 'true' ]; then
    msg_error2 "unrecognized option \'$ARG\'"
    exit 1
# FAIL: arg empty:
elif [ "$FLAG_ARG_EMPTY" = 'true' ]; then
    msg_error2 "option \'$ARG\' requires an argument"
    exit 1
fi

##=============================  SCRIPT  =============================##
# FAIL: more than one operation:
if [ $OPERATIONS_COUNT -gt 1 ]; then
    msg_error2 'only one operation may be used at a time'
    exit 1
fi
# FAIL: devtools required to build packages:
if [ "$FLAG_BUILD" = 'true' ] && \
! (pacman -Q devtools &>/dev/null); then
    msg_error2 "\'devtools\' required to build packages"
    exit 5
fi
# FAIL: gnupg required to sign files:
if ! (pacman -Q gnupg &>/dev/null); then
    msg_warn2 "\'gnupg\' required to sign files"
    exit 5
fi

# set custom repo database from argument:
if [ -n "$ARG_REPO" ]; then
    REPO_DB="$ARG_REPO"
# set custom repo database from ARC_REPO environment variable:
elif [ -n "$ARC_REPO" ]; then
    REPO_DB="$ARC_REPO"
fi

# user set repo:
if [ -n "$REPO_DB" ]; then
    # FAIL: custom repo does not exist:
    if [ ! -f "$REPO_DB" ]; then
        msg_error2 "\'$REPO_DB\' does not exist"
        exit 2
    fi
    # resolve link:
    if [ -h "$REPO_DB" ]; then
        REPO_DB="$(readlink "$REPO_DB")"
    fi
    # FAIL: invalid repo file extension:
    if ! (grep -P '^.*\.(db|files)\.(tar|tar\.(gz|bz2|xz|Z))$' \
    <<< "$REPO_DB" &>/dev/null ); then
        msg_error2 "\'$REPO_DB\' invalid repository database"
        exit 2
    fi
# attempt to set repo from script directory:
elif [ -f "$DIR_SCRIPT/repo/arc-repo.db.tar.gz" ]; then
    REPO_DB="$DIR_SCRIPT/repo/arc-repo.db.tar.gz"
elif [ -f "$DIR_SCRIPT/arc-repo.db.tar.gz" ]; then
    REPO_DB="$DIR_SCRIPT/arc-repo.db.tar.gz"
# FAIL: no repo database found:
else
    msg_error2 "no repository database found"
    exit 2
fi

# set repo directory and name:
REPO_DIR="$( cd "$( dirname "$REPO_DB" )" && pwd )"
REPO_NAME="$(basename "$REPO_DB")"
REPO_NAME="${REPO_NAME%%.*}"
REPO_CACHE_DIR="$REPO_DIR/cache"
REPO_PKGBUILD_DIR="$REPO_DIR/pkgbuild"
mkdir -p "$REPO_CACHE_DIR"
mkdir -p "$REPO_PKGBUILD_DIR"
# get repo package information:
arc_repo_refresh
# FAIL: package count error:
if [ ${#REPO_PKG_NAMES[@]} -ne ${#REPO_PKG_VERSIONS[@]} ]; then
    msg_error 'repo database package count mismatch'
    exit 2
fi

# FAIL: gpg-key arg not found:
if  [ -n "$ARG_GPG_KEY" ] &&
! (gpg --list-secret-keys "$ARG_GPG_KEY" &>/dev/null); then
    msg_error2 "gpg key \'$ARG_GPG_KEY\' not found"
    exit 5
elif [ -n "$ARG_GPG_KEY" ]; then
    GPG_USER_ARG="-u $ARG_GPG_KEY"
fi
# FAIL: signing but no gpg keys found:
if [ "$FLAG_SIGN" = 'true' ] &&
! (gpg --list-secret-keys | grep -P '^sec\s' &>/dev/null); then
    msg_error2 "no secret gpg keys found"
    exit 5
fi

# call repo operation:
if [ "$FLAG_BUILD" = 'true' ]; then
    arc_repo_build
elif [ "$FLAG_DATABASE" = 'true' ]; then
    arc_repo_database
elif [ "$FLAG_GIT" = 'true' ]; then
    arc_repo_git
elif [ "$FLAG_QUERY" = 'true' ]; then
    arc_repo_query
fi

exit $?
# exit codes:
# 0 - all good
# 1 - arg error
# 2 - file/database error
# 3 - build error
# 4 - query error
# 5 - missing dependency

# vim:ft=bash
