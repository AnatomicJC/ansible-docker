# ansible-docker

## Build

Set the version you want to build with `--build-arg`

```
docker build --build-arg ANSIBLE_VERSION=2.9.1 -t ansible:2.9.1 .
```

## Helper scripts

```
ln -s ~/path/to/ansible-docker/bin/* ~/.local/bin/
```
