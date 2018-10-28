
# s2i-builder-rpm
FROM openshift/base-centos7
#FROM centos/s2i-core-centos7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Your Name <your@email.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN yum install -y rpmdevtools.noarch rpm-build redhat-rpm-config \
    rpmlint make gcc \ 
    asciidoc cmlto emacs libsecret-devel pcre2-devel \ 
    pkgconfig bash-completion \
    python2-devel perl-ExtUtils-MakeMaker libgnome-keyring-devel xmlto \
    expat-devel libcurl-devel openssl-devel zlib-devel perl-Error \
    && yum clean all -y

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/
COPY ./build.sh ${HOME}/build.sh
#COPY ./rpmbuild ${HOME}/rpmbuild
#COPY ./git-2.14.2-2.fc27.src.rpm ${HOME}/git-2.14.2-2.fc27.src.rpm 

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:0 /opt/app-root && \
    chmod 775 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
CMD ["/usr/libexec/s2i/run"]
