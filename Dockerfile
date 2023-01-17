FROM osimis/orthanc:22.11.4-full

ENV STONE_WEB_VIEWER_PLUGIN_ENABLED=true
ENV VERBOSE_STARTUP=true
ENV VERBOSE_ENABLED=true

COPY ./orthanc.json /etc/orthanc

## Update Libraries (from Microsoft Defender Recommendations)
RUN apt-get clean && \
    apt-get update && \
    apt-get -y install \
        libgssapi-krb5-2=1.18.3-6+deb11u3 \
        libkrb5-3=1.18.3-6+deb11u3 \
        libk5crypto3=1.18.3-6+deb11u3 \
        libkrb5support0=1.18.3-6+deb11u3 \
        libpixman-1-0=0.40.0-1.1~deb11u1 \
        libxml2=2.9.10+dfsg-6.7+deb11u3