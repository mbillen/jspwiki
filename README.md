[![GitHub Release](https://img.shields.io/github/v/tag/mbillen/jspwiki.svg?logo=github&style=flat-square)](https://github.com/mbillen/jspwiki/tags)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/mbillen/jspwiki/docker-publish.yml?label=ci&logo=github&style=flat-square)](https://github.com/mbillen/jspwiki/actions?workflow=docker)

## About

JSPWiki is a simple (well, not anymore) WikiWiki clone, written in Java and JSP.  A WikiWiki is a website which allows anyone to participate in its development.  JSPWiki supports all the traditional wiki features, as well as very detailed access control and security integration using JAAS. 

* For more information see https://jspwiki-wiki.apache.org/
___

## Usage/Examples

Run a JSPWiki container on host port 8080 with a default configuration. 

```bash
docker run --name jspwiki \
  -p 8080:8080/tcp \
  ghcr.io/mbillen/jspwiki
```

Optionally create a bind mount to store you Wiki pages between container restarts.

```bash
docker run --name jspwiki \
  -p 8080:8080/tcp \
  -v /path/on/host:/var/jspwiki \
  ghcr.io/mbillen/jspwiki
```

The directory structure within the mounted directory is as follows:

```md
jspwiki
├── pages
├── etc 
├── logs
└── work
```
___
## Changes to the official [Docker image](https://jspwiki-wiki.apache.org/Wiki.jsp?page=Docker)

* changed directory structure (see above)
* modified policy to prevent page modifications without being authorized (except sandbox)
* added InterWiki links for *Lotus Notes* and *AdBlock Plus*
* completely disabled cache for `BasicAttachmentProvider`
* using German language
___
## Customizing

All parameters of the [JSPWiki configuration file](https://github.com/apache/jspwiki/blob/master/jspwiki-main/src/main/resources/ini/jspwiki.properties) can be overwritten using environment variables within the container's environment. Every "_" in the variables is converted to ".". To change the name attribute of your Wiki simply set the variable jspwiki_applicationName.

```bash
docker run --name jspwiki \
  -p 8080:8080/tcp \
  -e jspwiki_applicationName='MyWiki' \
  ghcr.io/mbillen/jspwiki
```
