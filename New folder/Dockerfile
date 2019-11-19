FROM openjdk:11-jdk-stretch


RUN apt-get update \
    && apt-get install -y curl gnupg2 unzip \
    && rm -rf /var/lib/apt/lists/*



ENV SONAR_VERSION=7.9.1 \
    SONARQUBE_HOME=/opt/sonarqube \
    SQ_HTML_VERSION=3.2.0.2082 \
    SQ_PMD_VERSION=3.2.1 \
    SQ_CHECKSTYLE_VERSION=4.23 \
    SQ_JACOCO_VERSION=1.0.2.475 \
    SQ_ANSIBLE_VERSION=2.1.0 \
    SQ_JAVA_VERSION=5.14.0.18788 \
    SQ_JS_VERSION=5.2.1.7778 \
    SQ_JDEPEND_VERSION=1.1.1 \
    SQ_GIT_VERSION=1.9.1.1834 \
    SQ_CSS_VERSION=1.1.1.1010 \
    SQ_SVN_VERSION=1.9.0.1295 \
    SQ_FB_VERSION=3.11.1 \
    SQ_TS_VERSION=1.9.0.3766 \
    SQ_FLEX_VERSION=2.5.1.1831 \
    SQ_XML_VERSION=2.0.1.2020 \
    SQ_DEPENDENCY_CHECK_VERSION=1.2.6 \
    SQ_OIDC_VERSION=1.0.4 \
    SQ_SOFTVIZ3D_VERSION=1.1.0 \
    # Database configuration
    # Defaults to using H2
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

# Http port
EXPOSE 9000

RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube

# pub   2048R/D26468DE 2015-05-25
#       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
# uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
# sub   2048R/06855C1D 2015-05-25
RUN for server in $(shuf -e ha.pool.sks-keyservers.net \
                            hkp://p80.pool.sks-keyservers.net:80 \
                            keyserver.ubuntu.com \
                            hkp://keyserver.ubuntu.com:80 \
                            pgp.mit.edu) ; do \
        gpg --batch --keyserver "$server" --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE && break || : ; \
    done

RUN set -x \
    && rm -rf /opt \
    && mkdir /opt \
    && cd /opt \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip -q sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/extensions/plugins/* \
    && cd $SONARQUBE_HOME/extensions/plugins/ \
    && curl -o sonar-scm-git-plugin-$SQ_GIT_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-scm-git-plugin/sonar-scm-git-plugin-$SQ_GIT_VERSION.jar \
    && curl -o sonar-scm-svn-plugin-$SQ_SVN_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-scm-svn-plugin/sonar-scm-svn-plugin-$SQ_SVN_VERSION.jar \
    && curl -o sonar-jacoco-plugin-$SQ_JACOCO_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-jacoco-plugin/sonar-jacoco-plugin-$SQ_JACOCO_VERSION.jar \
    && curl -o sonar-java-plugin-$SQ_JAVA_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-java-plugin/sonar-java-plugin-$SQ_JAVA_VERSION.jar \
    && curl -o sonar-xml-plugin-$SQ_XML_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-xml-plugin/sonar-xml-plugin-$SQ_XML_VERSION.jar \
    && curl -o sonar-javascript-plugin-$SQ_JS_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-javascript-plugin/sonar-javascript-plugin-$SQ_JS_VERSION.jar \
    && curl -o sonar-typescript-plugin-$SQ_TS_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-typescript-plugin/sonar-typescript-plugin-$SQ_TS_VERSION.jar \
    && curl -o sonar-css-plugin-$SQ_CSS_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-css-plugin/sonar-css-plugin-$SQ_CSS_VERSION.jar \
    && curl -o sonar-html-plugin-$SQ_HTML_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-html-plugin/sonar-html-plugin-$SQ_HTML_VERSION.jar \
    && curl -o sonar-flex-plugin-$SQ_FLEX_VERSION.jar -fSL https://binaries.sonarsource.com/Distribution/sonar-flex-plugin/sonar-flex-plugin-$SQ_FLEX_VERSION.jar \
    && curl -o sonar-findbugs-plugin-$SQ_FB_VERSION.jar -fSL https://github.com/spotbugs/sonar-findbugs/releases/download/$SQ_FB_VERSION/sonar-findbugs-plugin-$SQ_FB_VERSION.jar \
    && curl -o sonar-dependency-check-plugin-${SQ_DEPENDENCY_CHECK_VERSION}.jar -fSL https://github.com/dependency-check/dependency-check-sonar-plugin/releases/download/${SQ_DEPENDENCY_CHECK_VERSION}/sonar-dependency-check-plugin-${SQ_DEPENDENCY_CHECK_VERSION}.jar \
    && curl -o sonar-auth-oidc-plugin-${SQ_OIDC_VERSION}.jar -fSL https://github.com/vaulttec/sonar-auth-oidc/releases/download/v${SQ_OIDC_VERSION}/sonar-auth-oidc-plugin-${SQ_OIDC_VERSION}.jar \
    && curl -o sonar-softvis3d-plugin-${SQ_SOFTVIZ3D_VERSION}.jar -fSL https://github.com/stefanrinderle/softvis3d/releases/download/softvis3d-${SQ_SOFTVIZ3D_VERSION}/sonar-softvis3d-plugin-${SQ_SOFTVIZ3D_VERSION}.jar \
    && rm -rf $SONARQUBE_HOME/bin/*
 

VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
USER sonarqube
ENTRYPOINT ["./bin/run.sh"]