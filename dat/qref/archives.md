---
title: Archive and Compression Formats
---

This document details a bunch of common archive and compression formats and
gives actual commands to compress/decompress them.

# Archive
Archive only formats don't compress data at all (sometimes they actually use
more disk space). Rather they are used to combine a bunch of files/directories
into a single archive file. This archive is then usually compressed by one of
any number of separate compression algorithms. This is why you commonly see
files like *name.tar.gz*; this is a *tar* archive that was compressed by
*gzip*. Some tools (bsdtar, tar) may call the compression program all in one
step.

| ext | name | `file -b` | tools |
|----|----|----|----|
| .a .ar | [unix archiver](https://en.wikipedia.org/wiki/Ar_(Unix)) | ? | [ar](https://man7.org/linux/man-pages/man1/ar.1.html) |
| .cpio | [cpio](https://en.wikipedia.org/wiki/Cpio) | ASCII cpio archive | [bsdtar](https://man.freebsd.org/cgi/man.cgi?query=bsdtar) [bsdcpio](https://man.freebsd.org/cgi/man.cgi?query=bsdcpio) |
| .shar | shell archive | ? | ? |

## cpio
- file: ASCII cpio archive
- extension: .cpio

Create:

    $ bsdtar caf <NAME>.cpio <FILE...>

Extract:

    $ bsdtar xf <FILE> [-f FILE]...
    $ bsdcpio -i -F <FILE> [-F FILE]...

# Compress

## zstd
- file: Zstandard compressed data
- extension: .zst

Create:

    $ bsdtar --zstd:compression-level=19 -caf <NAME>.tar.zst <FILE...>
    $ bsdtar c <FILE...> | zstd -19 -o <NAME>.tar.zst

Extract:

    $ bsdtar xf <FILE> [-f FILE]...
    $ zstd -c -d <FILE> | bsdtar x
    $ zstd -d <FILE...>

----

## 7-zip
- file: 7-zip archive data
- extensions: 7z

Create:

    $ bsdtar caf <NAME>.7z <FILE...>
    $ 7z a <NAME>.7z <FILE...>

Extract:

    $ bsdtar xf <ARCHIVE>
    $ 7z x <ARCHIVE>

## lz4
- file: LZ4 compressed data
- extensions: lz4
- single-file
- requires: lz4

Create:

    $ bsdtar caf <NAME>.lz4 <FILE...>

Extract:

    $ bsdtar xf <ARCHIVE>
    $ 7z x <ARCHIVE>

## lzo
- file: lzop compressed data
- extensions: lzo
- requires: lzop

Create:

    $ bsdtar caf <NAME>.lzo <FILE...>

Extract:

    $ bsdtar xf <ARCHIVE>

----

## lrzip
- file: LRZIP compressed data
- extensions: zpaq, lrz

Create:

    $ bsdtar caf <NAME>.lzo <FILE...>

Extract:

    $ bsdtar xf <ARCHIVE>


# iso
ISO 9660 CD-ROM filesystem data

## bsdtar xf
- 7-zip archive data
- ISO 9660 CD-ROM filesystem data
- LZMA compressed data
- POSIX tar archive
- XZ compressed data
- Zstandard compressed data
- bzip2 compressed data
- gzip compressed data
- uuencoded text
- zip archive data
- Microsoft Cabinet archive data
- LRZIP compressed data
- lzop compressed data
- ASCII cpio archive

## 7z x
- 7-zip archive data
- ARJ archive data
- ISO 9660 CD-ROM filesystem data
- LZMA compressed data
- POSIX tar archive
- Windows imaging (WIM) image
- XZ compressed data
- Zstandard compressed data
- bzip2 compressed data
- gzip compressed data
- zip archive data
- Microsoft Cabinet archive data

## bsdcpio
- ASCII cpio archive

## unzip
- zip archive data

## unrar

## lrzip

# Extraction


# Summary
bsdtar is pretty much the only extraction program needed. It can extract 95% of
common archive types.

Archive creation is a little more tricky. For most uses, *.tar.zst* is going
to be the best archive format; this is easily created with bsdtar. The
creation of some less popular archive formats require external programs in
conjunction with bsdtar, or the direct use of external programs themselves
(e.g. *.lzo* archive can be created with bsdtar as long as `/usr/bin/lzop` is
available).

[wikipedia](https://en.wikipedia.org/wiki/List_of_archive_formats)


<!-- vim: set ft=markdown: -->
