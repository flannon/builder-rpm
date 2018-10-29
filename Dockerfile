
# s2i-builder-rpm
FROM openshift/base-centos7
#FROM centos/s2i-core-centos7

MAINTAINER Flannon Jackson <flannon@nyu.edu>

ENV BUILDER_VERSION 0.1.0

LABEL io.k8s.description="Platform for building src rpms" \
      io.k8s.display-name="builder rpm" \
      io.openshift.expose-services="" \
      io.openshift.tags="builder,rpm,etc." \
      url="https://github.com/flannon/builder-rpm" \
      run='docker run -tdi --name ${NAME} \
      -u 12345 \
      ${IMAGE}' 

RUN yum install -y rpmdevtools.noarch rpm-build redhat-rpm-config \
    rpmlint make gcc \ 
    asciidoc cmlto emacs libsecret-devel pcre2-devel \ 
    pkgconfig bash-completion \
    python2-devel perl-ExtUtils-MakeMaker libgnome-keyring-devel xmlto \
    expat-devel libcurl-devel openssl-devel zlib-devel perl-Error \
    && yum clean all -y

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/app-root
ENV PATH=${APP_ROOT}/bin:${PATH} HOME=${APP_ROOT}
COPY bin/ ${APP_ROOT}/bin/
#COPY ./build.sh ${HOME}/build.sh
RUN chmod -R u+x ${APP_ROOT}/bin && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd
    #chown -R 1001:0 /opt/app-root && \
    #chmod -R 775 /opt/app-root

#COPY ./rpmbuild ${HOME}/rpmbuild
#COPY ./git-2.14.2-2.fc27.src.rpm ${HOME}/git-2.14.2-2.fc27.src.rpm 

COPY ./s2i/bin/ /usr/libexec/s2i

# This default user is created in the openshift/base-centos7 image
USER 1001
WORKDIR ${APP_ROOT}

### user name recognition at runtime w/ an arbitrary uid - for OpenShift deployments
ENTRYPOINT [ "bin/uid_entrypoint" ]
VOLUME ${APP_ROOT}/logs ${APP_ROOT}/data
CMD ["/usr/libexec/s2i/run"]
