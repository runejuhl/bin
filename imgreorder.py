#!/usr/bin/env python
import pyexiv2
import sys, os, datetime

import argparse

IMAGE_EXT=('.jpg', '.JPG')
MOVIE_EXT=('.mov', '.MOV')


class ImgReorder(rootdir='.', verbose=False, move=False, pickle='imgreorder.pickle'):
    def __init__(self, **kwargs):
        vars(self).update(kwargs)

    def main(self):

        for (dirpath, dirnames, filenames) in os.walk(rootdir):
            for filename in filenames:
                # join directory and filename
                filename = os.path.join(dirpath, filename)

                timestamp = False   # sentinel

                if filename.endswith(IMAGE_EXT):
                    # try to read EXIF data
                    try:
                        metadata = pyexiv2.ImageMetadata(filename)
                        metadata.read()
                    except IOError:
                        if verbose:
                            print filename, ' unknown to pyexiv2, skipping.'
                        continue

                    # try to get DateTime from EXIF
                    try:
                        timestamp = metadata['Exif.Image.DateTime'].value
                    except KeyError:
                        if verbose:
                            print filename, ' has no exif keys.'

                # if file isn't a JPEG, or if we couldn't extract EXIF data,
                # default to ctime
                if not timestamp:
                    timestamp = datetime.datetime.fromtimestamp(os.stat(filename).st_mtime)

                ymd = os.path.join(*map(lambda x: timestamp.strftime('%' + x), ['Y', 'm', 'd']))
                newpath = os.path.join(os.curdir, ymd, os.path.basename(filename))

                try:
                    os.renames(filename, newpath)
                    if verbose:
                        print filename, 'moved to ', newpath
                except:
                    if verbose:
                        print filename, ': unable to move (newpath: ', newpath, ')'

if __name__ == '__main__':
    # verbose output?
    verbose = '--verbose' in sys.argv
    # the working dir is the first argument that doesn't start with '--'
    rootdir = filter(lambda x: not x.startswith('--'), sys.argv)[1]

    main()
