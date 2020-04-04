#!/bin/bash

if [[ "${1}" == "yesterday" || "${1}" == "today" ]]; then
	TABLE="main_table_countries_${1}"
else
    echo "Parameter wrong or missing" && exit 1
fi

FILENAME="${1}"

getTable() {
    echo $(echo ${1} | grep -o "<table id=\"${2}\".*<\/table>")
}

toJson() {
	ROWS=$(echo ${1} | xmllint --html --xpath "count(//tr)" - 2>/dev/null)
	COLUMNS=$(echo ${1} | xmllint --html --xpath "count(//tr[1]/th)" - 2>/dev/null)

	COLS=0
	for col in $(seq ${COLUMNS}); do
		if [[ "$(echo ${1} | xmllint --html --xpath "string(//tr[1]//th[$col])" - 2>/dev/null | awk '{print $1}')" ]]; then
			COLS=$((++COLS))
		fi
	done

	XPATH=""
	for row in $(seq ${ROWS}); do
		XPATH+="'{',"
		for col in $(seq ${COLS}); do
			XPATH+="'\"',//tr[1]//th[$col],'\":\"',//tr[$row]//td[$col],'\",',"
		done
		XPATH+="'},',"
	done

XPATH=$(echo {$1} | xmllint --html --xpath "concat($(echo ${XPATH} | sed 's/.$//'))" - 2>/dev/null | sed 's/",}/"}/g' | sed 's/..$//')
echo "[${XPATH}}]" > ${2}.json
}

WEBSITE=$(curl -s https://www.worldometers.info/coronavirus/)
TABLE=$(echo $(getTable "${WEBSITE}" "${TABLE}"))
toJson "${TABLE}" "${FILENAME}"
