## Docker

### How to build the docker image?

```bash
cd docker
mkdir -p mxe_mingw_qt6

#Copy mxe code into temporary folder (this is to prevent transfering too many data into the docker build context)
rsync -avp --delete ../* ../.* --exclude docker mxe_mingw_qt6/

#build image (replace xxxxxx with version tag)
docker build -t raoulh/mxe_qt6:xxxxxx .

#push image to registry (replace xxxxxx with version tag)
docker push raoulh/mxe_qt6:xxxxxx
```
