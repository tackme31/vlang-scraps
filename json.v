import json

struct SolrResult {
	response SolrResponse
}

struct SolrResponse {
	num_found int [json:numFound]
	start int
	docs []string
}

fn main() {
	s := '{"response":{"numFound": 0, "start":0, "docs":[]}}'
	users := json.decode(SolrResult, s) or {
		exit
	}
}