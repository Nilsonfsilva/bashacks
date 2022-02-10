bh_hashcrack() {
	# argc must be equals to 1
	[ $# -ne 1 ] && return 1

	# if '${HOME}/.config/bashacks/' not exist
	[ ! -d "$BASHACKS_CACHEDIR" ] && {
		mkdir -p "$BASHACKS_CACHEDIR"
		> "${BASHACKS_CACHEDIR}/hash"
   }
    
   local hash="$1"
   local site="https://hashtoolkit.com/decrypt-hash/?hash=$hash"

   # cache search
   CACHE=$(grep "${hash}:" "${BASHACKS_CACHEDIR}/hash" )

   if [ "$CACHE" ]; then
		# getting the plaintext that is hashed
		res=$(cut -d ':' -f2 <<< "$CACHE")

	# if the hash has not been looked up previously
	else
		# bh_cmd_wget is an alias, see: src/internal/bh_bootstrap.sh
      res=$(bh_cmd_wget -qO - "$site" \
			| sed -n '/.*generate-hash\/?text=\(.*\)\".*/{s//\1/p;q;}')

      # saving data on cache
      [ "$res" ] && \
			echo "${hash}:$res" >> "${BASHACKS_CACHEDIR}/hash"
	fi

	echo "$res"

}
