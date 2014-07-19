#!/bin/sh

die() {
    echo $1
    exit 1
}

if [ $# != 1 ]; then
    die "Usage: $0 <ffmpeg-source>"
fi

src=$1
current_dir=$(pwd)

export FFMPEG_EXTRA_HEAD="$(cat src/template_doc_head1)"
export FFMPEG_AFTER_BODY_OPEN="$(cat src/template_doc_head2)"
export FFMPEG_BEFORE_TITLE="$(cat src/template_doc_head3)"
export FFMPEG_AFTER_HEADER="$(cat src/template_doc_head4)"
export FFMPEG_PRE_BODY_CLOSE="$(cat src/template_footer1 src/template_footer_prod src/template_footer2)"

rm -rf build-doc
mkdir build-doc && cd build-doc
$src/configure --enable-gpl --disable-yasm || die "configure failed"
make doc || die "doc not made"
cp doc/*.html ../htdocs/ || die "copy failed"

rm -rf build-doc