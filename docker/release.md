Release steps:

 1. In 'master' branch update the new version in ${BRANCH} in docker files and also in debian/changelog and rpm/openscpu.spec
 2. On Github tag a release from master. This will automatically initiate the builds on dockerhub
 3. If everything on Dockerhub went fine, merge master into v2.0 (stable)
 