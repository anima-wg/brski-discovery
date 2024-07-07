DRAFT:=draft-ietf-anima-brski-discovery

html: xml
	xml2rfc --v2v3 ${DRAFT}.xml && mv ${DRAFT}.v2v3.xml ${DRAFT}.xml
	xml2rfc ${DRAFT}.xml --html

xml:
	kdrfc -3 ${DRAFT}.md

submit: ${DRAFT}.xml
	curl -S -F "user=tte@cs.fau.de" -F "xml=@${DRAFT}.xml" https://datatracker.ietf.org/api/submission | jq

