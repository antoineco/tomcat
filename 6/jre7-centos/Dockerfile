FROM antoineco/openjdk:7-jre-centos

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

# let "Tomcat Native" live somewhere isolated
ENV TOMCAT_NATIVE_LIBDIR $CATALINA_HOME/native-jni-lib
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

# runtime dependencies for Tomcat Native Libraries
# Tomcat Native 1.2+ requires a newer version of OpenSSL than centos:7 has available
# > Found   OPENSSL_VERSION_NUMBER 0x1000105f (OpenSSL 1.0.1e 11 Feb 2013)
# > Require OPENSSL_VERSION_NUMBER 0x1000200f or greater (1.0.2)
# > configure: error: Your version of OpenSSL is not compatible with this version of tcnative
# see http://tomcat.10.x6.nabble.com/VOTE-Release-Apache-Tomcat-8-0-32-tp5046007p5046024.html (and following discussion)
# and https://github.com/docker-library/tomcat/pull/31
ENV OPENSSL_VERSION 1.0.2k
RUN yum install -y \
	https://downloads.ulyaoth.net/rpm/ulyaoth-latest.centos.x86_64.rpm \
# disable Ulyaoth repo by default
	&& yum-config-manager --disable ulyaoth \
	&& yum install -y \
		apr \
	&& yum install -y --enablerepo ulyaoth \
		ulyaoth-openssl1.0.2-libs-$OPENSSL_VERSION \
	&& yum clean all --enablerepo=ulyaoth

# see https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/KEYS
# see also "generate-dockerfiles.sh" (https://github.com/antoineco/tomcat/blob/master/generate-dockerfiles.sh)
ENV GPG_KEYS 05AB33110949707C93A279E3D3EFE6B686867BA6 07E48665A34DCAFAE522E5E6266191C37C037D42 47309207D818FFD8DCD3F83F1931D684307A10A5 541FBE7D8F78B25E055DDEE13C370389288584E7 61B832AC2F1C5A90F0F9B00A1C506407564C17A3 713DA88BE50911535FE716F5208B0AB1D63011C7 79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED 80FF76D88A969FE46108558A80B953A041E49465 8B39757B1D8A994DF2433ED58B3A601F08C975E5 A27677289986DB50844682F8ACB77FC2E86E29AC A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 B3F49CD3B9BD2996DA90F817ED3873F5D3262722 DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
RUN set -ex; \
	for key in $GPG_KEYS; do \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	done

ENV TOMCAT_MAJOR 6
ENV TOMCAT_VERSION 6.0.51

# https://issues.apache.org/jira/browse/INFRA-8753?focusedCommentId=14735394#comment-14735394
ENV TOMCAT_TGZ_URL https://www.apache.org/dyn/closer.cgi?action=download&filename=tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
# not all the mirrors actually carry the .asc files :'(
ENV TOMCAT_ASC_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz.asc

RUN set -x \
	\
	&& curl -sSLo tomcat.tar.gz "$TOMCAT_TGZ_URL" \
	&& curl -sSLo tomcat.tar.gz.asc "$TOMCAT_ASC_URL" \
	&& gpg --batch --verify tomcat.tar.gz.asc tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz* \
	\
	&& nativeBuildDir="$(mktemp -d)" \
	&& tar -xvf bin/tomcat-native.tar.gz -C "$nativeBuildDir" --strip-components=1 \
# get OpenSSL from Ulyaoth repo
	&& buildDepsUlyaoth=" \
		ulyaoth-openssl1.0.2-devel-$OPENSSL_VERSION \
	" \
	&& nativeBuildDeps=" \
		gcc \
		apr-devel \
		make \
		java-1.${JAVA_VERSION%%[-~bu]*}.0-openjdk-devel-$JAVA_CENTOS_VERSION \
	" \
	&& yum install -y $nativeBuildDeps \
	&& yum install -y --enablerepo ulyaoth $buildDepsUlyaoth \
	&& yum clean all --enablerepo=ulyaoth \
	&& ( \
		export CATALINA_HOME="$PWD" \
		&& cd "$nativeBuildDir/native" \
		&& ./configure \
			--libdir="$TOMCAT_NATIVE_LIBDIR" \
			--prefix="$CATALINA_HOME" \
			--with-apr="$(which apr-1-config)" \
			--with-java-home="$(docker-java-home)" \
			--with-ssl=/usr/local/ulyaoth/openssl1.0.2 \
		&& make -j$(nproc) \
		&& make install \
	) \
	&& yum history -y rollback last-2 \
	&& find /etc -mindepth 2 -name *.rpmsave -exec rm -v '{}' + \
	&& rm -rf /usr/share/java \
	&& rm -rf "$nativeBuildDir" \
	&& rm bin/tomcat-native.tar.gz

# verify mod_cluster is working properly
RUN set -e \
	&& catalina.sh start \
	&& while ! grep -q 'Server startup in' logs/catalina.out; do \
		echo -n .; sleep .2; \
	done; echo \
	&& catalina.sh stop \
	&& while pgrep java >/dev/null; do \
		echo -n .; sleep .2; \
	done; echo \
	&& nativeLines="$(grep 'Apache Tomcat Native' logs/catalina.out)" \
	&& nativeLines="$(echo "$nativeLines" | sort -u)" \
	&& if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
		echo >&2 "$nativeLines"; \
		exit 1; \
	fi \
	&& rm -rf conf/Catalina work/Catalina logs/*

EXPOSE 8080
CMD ["catalina.sh", "run"]
