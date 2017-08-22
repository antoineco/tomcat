#!/bin/bash
set -eo pipefail

# docker run -it --rm buildpack-deps:curl
# curl -fsSL 'https://www.apache.org/dist/tomcat/tomcat-9/KEYS' | gpg --import
# gpg --fingerprint | grep 'Key fingerprint =' | cut -d= -f2 | sed -r 's/ +//g' | sort
declare -A gpgKeys=(
	# gpg: key F22C4FED: public key "Andy Armstrong <andy@tagish.com>" imported
	# gpg: key 86867BA6: public key "Jean-Frederic Clere (jfclere) <JFrederic.Clere@fujitsu-siemens.com>" imported
	# gpg: key E86E29AC: public key "kevin seguin <seguin@apache.org>" imported
	# gpg: key 307A10A5: public key "Henri Gomez <hgomez@users.sourceforge.net>" imported
	# gpg: key 564C17A3: public key "Mladen Turk (*** DEFAULT SIGNING KEY ***) <mturk@apache.org>" imported
	# gpg: key 7C037D42: public key "Yoav Shapira <yoavs@apache.org>" imported
	# gpg: key 33C60243: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 2F6059E7: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 288584E7: public key "R�my Maucherat <remm@apache.org>" imported
	# gpg: key 0D811BBE: public key "Yoav Shapira <yoavs@computer.org>" imported
	# gpg: key 731FABEE: public key "Tim Whittington (CODE SIGNING KEY) <timw@apache.org>" imported
	# gpg: key 0D498E23: public key "Mladen Turk (Default signing key) <mturk@apache.org>" imported
	# gpg: Total number processed: 12
	[9]='
		05AB33110949707C93A279E3D3EFE6B686867BA6
		07E48665A34DCAFAE522E5E6266191C37C037D42
		47309207D818FFD8DCD3F83F1931D684307A10A5
		541FBE7D8F78B25E055DDEE13C370389288584E7
		61B832AC2F1C5A90F0F9B00A1C506407564C17A3
		79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED
		9BA44C2621385CB966EBA586F72C284D731FABEE
		A27677289986DB50844682F8ACB77FC2E86E29AC
		A9C5DF4D22E99998D9875A5110C01C5A2F6059E7
		DCFD35E0BF8CA7344752DE8B6FB21E8933C60243
		F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE
		F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
	'

	# gpg: key F22C4FED: public key "Andy Armstrong <andy@tagish.com>" imported
	# gpg: key 86867BA6: public key "Jean-Frederic Clere (jfclere) <JFrederic.Clere@fujitsu-siemens.com>" imported
	# gpg: key E86E29AC: public key "kevin seguin <seguin@apache.org>" imported
	# gpg: key 307A10A5: public key "Henri Gomez <hgomez@users.sourceforge.net>" imported
	# gpg: key 564C17A3: public key "Mladen Turk (*** DEFAULT SIGNING KEY ***) <mturk@apache.org>" imported
	# gpg: key 7C037D42: public key "Yoav Shapira <yoavs@apache.org>" imported
	# gpg: key 33C60243: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 2F6059E7: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 288584E7: public key "R�my Maucherat <remm@apache.org>" imported
	# gpg: key 0D811BBE: public key "Yoav Shapira <yoavs@computer.org>" imported
	# gpg: key 731FABEE: public key "Tim Whittington (CODE SIGNING KEY) <timw@apache.org>" imported
	# gpg: key 0D498E23: public key "Mladen Turk (Default signing key) <mturk@apache.org>" imported
	# gpg: key D63011C7: public key "Violeta Georgieva Georgieva (CODE SIGNING KEY) <violetagg@apache.org>" imported
	# gpg: Total number processed: 13
	[8]='
		05AB33110949707C93A279E3D3EFE6B686867BA6
		07E48665A34DCAFAE522E5E6266191C37C037D42
		47309207D818FFD8DCD3F83F1931D684307A10A5
		541FBE7D8F78B25E055DDEE13C370389288584E7
		61B832AC2F1C5A90F0F9B00A1C506407564C17A3
		713DA88BE50911535FE716F5208B0AB1D63011C7
		79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED
		9BA44C2621385CB966EBA586F72C284D731FABEE
		A27677289986DB50844682F8ACB77FC2E86E29AC
		A9C5DF4D22E99998D9875A5110C01C5A2F6059E7
		DCFD35E0BF8CA7344752DE8B6FB21E8933C60243
		F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE
		F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
	'

	# gpg: key F22C4FED: public key "Andy Armstrong <andy@tagish.com>" imported
	# gpg: key 86867BA6: public key "Jean-Frederic Clere (jfclere) <JFrederic.Clere@fujitsu-siemens.com>" imported
	# gpg: key E86E29AC: public key "kevin seguin <seguin@apache.org>" imported
	# gpg: key 307A10A5: public key "Henri Gomez <hgomez@users.sourceforge.net>" imported
	# gpg: key 564C17A3: public key "Mladen Turk (*** DEFAULT SIGNING KEY ***) <mturk@apache.org>" imported
	# gpg: key 7C037D42: public key "Yoav Shapira <yoavs@apache.org>" imported
	# gpg: key 33C60243: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 2F6059E7: public key "Mark E D Thomas <markt@apache.org>" imported
	# gpg: key 288584E7: public key "R�my Maucherat <remm@apache.org>" imported
	# gpg: key 0D811BBE: public key "Yoav Shapira <yoavs@computer.org>" imported
	# gpg: key 731FABEE: public key "Tim Whittington (CODE SIGNING KEY) <timw@apache.org>" imported
	# gpg: key 0D498E23: public key "Mladen Turk (Default signing key) <mturk@apache.org>" imported
	# gpg: key D63011C7: public key "Violeta Georgieva Georgieva (CODE SIGNING KEY) <violetagg@apache.org>" imported
	# gpg: Total number processed: 13
	[7]='
		05AB33110949707C93A279E3D3EFE6B686867BA6
		07E48665A34DCAFAE522E5E6266191C37C037D42
		47309207D818FFD8DCD3F83F1931D684307A10A5
		541FBE7D8F78B25E055DDEE13C370389288584E7
		61B832AC2F1C5A90F0F9B00A1C506407564C17A3
		713DA88BE50911535FE716F5208B0AB1D63011C7
		79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED
		9BA44C2621385CB966EBA586F72C284D731FABEE
		A27677289986DB50844682F8ACB77FC2E86E29AC
		A9C5DF4D22E99998D9875A5110C01C5A2F6059E7
		DCFD35E0BF8CA7344752DE8B6FB21E8933C60243
		F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE
		F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23
	'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

# see OPENSSL_VERSION in Dockerfile-centos.template
opensslVersionDebian="$(docker run -i --rm centos:7 bash -c 'yum install -y https://downloads.ulyaoth.net/rpm/ulyaoth-latest.centos.x86_64.rpm && yum info "$@"' -- 'ulyaoth-openssl1.0.2' |tac|tac| awk -F ': ' '$1 ~ /^Version/ { print $2; exit }')"

for version in "${versions[@]}"; do
	majorVersion="${version%%.*}"

	versionGpgKeys=( ${gpgKeys[$majorVersion]} )
	if [ "${#versionGpgKeys[@]}" -eq 0 ]; then
		echo >&2 "error: missing GPG fingerprints for $majorVersion"
		exit 1
	fi

	fullVersion="$(curl -fsSL --compressed "https://www.apache.org/dist/tomcat/tomcat-$majorVersion/" | grep '<a href="v'"$version." | sed -r 's!.*<a href="v([^"/]+)/?".*!\1!' | sort -V | tail -1)"

	for variant in "$version"/*/; do
		variant="$(basename "$variant")"
		javaVariant="${variant%%-*}"
		subVariant="${variant#$javaVariant-}"
		[ "$subVariant" != "$variant" ] || subVariant=

		baseImage='antoineco\/openjdk'
		case "$javaVariant" in
			jre*|jdk*)
				baseImage+=":${javaVariant:3}-${javaVariant:0:3}${subVariant:+-$subVariant}" # ":7-jre" or ":7-jre-alpine"
				;;
			*)
				echo >&2 "not sure what to do with $version/$variant re: baseImage; skipping"
				continue
				;;
		esac

		(
			set -x
			cp -v "Dockerfile${subVariant:+-$subVariant}.template" "$version/$variant/Dockerfile"
			sed -ri \
				-e 's/^(ENV TOMCAT_VERSION) .*/\1 '"$fullVersion"'/' \
				-e 's/^(FROM) .*/\1 '"$baseImage"'/' \
				-e 's/^(ENV OPENSSL_VERSION) .*/\1 '"${opensslVersionDebian}"'/' \
				-e 's/^(ENV TOMCAT_MAJOR) .*/\1 '"$majorVersion"'/' \
				-e 's/^(ENV GPG_KEYS) .*/\1 '"${versionGpgKeys[*]}"'/' \
				"$version/$variant/Dockerfile"
		)

		readarray smokeTestBlock <<'EOD'

		# verify Tomcat Native is working properly
		RUN set -e \
			&& nativeLines="$(catalina.sh configtest 2>&1)" \
			&& nativeLines="$(echo "$nativeLines" | grep 'Apache Tomcat Native')" \
			&& nativeLines="$(echo "$nativeLines" | sort -u)" \
			&& if ! echo "$nativeLines" | grep 'INFO: Loaded APR based Apache Tomcat Native library' >&2; then \
				echo >&2 "$nativeLines"; \
				exit 1; \
			fi
EOD

		printf %s "${smokeTestBlock[@]#			}" >> "$version/$variant/Dockerfile"

		cat >> "$version/$variant/Dockerfile" <<-'EOD'

			EXPOSE 8080
			CMD ["catalina.sh", "run"]
		EOD

	done
done
