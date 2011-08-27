# libSBOLrdf: a Java library for parsing and serializing SBOL RDF.

We are in the process of setting up this repository.  When it is ready it will contain the code required to build libSBOLrdf.

## To checkout and build:

First, clone the repository:

    git clone git://github.com/SynBioDex/libSBOLrdf.git

Second, pull down the core submodule:

    git submodule init
    git submodule update

Third, build libSBOLrdf.jar:

    ant

## Pulling new versions

If you have an existing git repository for this project and want to pull from GitHub, you must also pull from the submodule directory.

    git pull
    cd core
    git pull

