FROM tomcat:9.0

WORKDIR $CATALINA_HOME

ARG JSPWIKI_VERSION=2.12.2

#
# set default environment entries to configure jspwiki
ENV CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom
ENV LANG de_DE.UTF-8
ENV jspwiki_frontPage Main
ENV jspwiki_pageProvider VersioningFileProvider
ENV jspwiki_fileSystemProvider_pageDir /var/jspwiki/pages
ENV jspwiki_attachment_provider BasicAttachmentProvider
ENV jspwiki_basicAttachmentProvider_storageDir /var/jspwiki/pages/attachments
ENV jspwiki_basicAttachmentProvider_disableCache .*
ENV jspwiki_workDir /var/jspwiki/work
ENV jspwiki_xmlUserDatabaseFile /var/jspwiki/etc/userdatabase.xml
ENV jspwiki_xmlGroupDatabaseFile /var/jspwiki/etc/groupdatabase.xml
ENV jspwiki_use_external_logconfig true
ENV jspwiki_interWikiRef_Notes Notes://%s
ENV jspwiki_interWikiRef_abp abp:%s

#
# install unzip utility
RUN set -x \
 && export DEBIAN_FRONTEND=noninteractive \
 && apt update \
 && apt upgrade -y \
 && apt install --fix-missing --quiet --yes unzip

#
# install jspwiki
RUN set -x \
# create directories where all jspwiki stuff will live
 && mkdir -p /var/jspwiki/pages \
 && mkdir -p /var/jspwiki/etc \
 && mkdir -p /var/jspwiki/work \
# remove default tomcat applications, we dont need them to run jspwiki
 && rm -rf $CATALINA_HOME/webapps.dist \
# download and deploy jspwiki
 && wget -O /tmp/JSPWiki.war -nv https://dlcdn.apache.org/jspwiki/${JSPWIKI_VERSION}/binaries/webapp/JSPWiki.war \
 && mkdir $CATALINA_HOME/webapps/ROOT \
 && unzip -q -d $CATALINA_HOME/webapps/ROOT /tmp/JSPWiki.war \
 && rm /tmp/JSPWiki.war \
# download and deploy wiki pages
 && wget -O /tmp/wikipages.zip -nv https://dlcdn.apache.org/jspwiki/${JSPWIKI_VERSION}/wikipages/jspwiki-wikipages-de-${JSPWIKI_VERSION}.zip \
 && unzip -q -d /tmp /tmp/wikipages.zip \
 && mv /tmp/jspwiki-wikipages-de-*/* /var/jspwiki/pages/ \
 && rm -rf /tmp/jspwiki-wikipages-de-*

#
# copy configuration files to CATALINA_HOME
COPY CATALINA_HOME_overlay/ $CATALINA_HOME/

#
# make port visible in metadata
EXPOSE 8080

#
# by default we start the Tomcat container when the docker container is started.
CMD ["/usr/local/tomcat/bin/catalina.sh", "run", ">", "/usr/local/tomcat/logs/catalina.out"]
