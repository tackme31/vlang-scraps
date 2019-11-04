import http
import json

struct SolrConnection {
	url string
	core string
}

struct SolrResult {
	response string [raw]
}

struct SolrResponse {
	num_found int [json:numFound]
	start int
	docs string [raw]
}

fn new_connection(url, core string) SolrConnection {
	return SolrConnection {
		url: url,
		core: core
	}
}

fn (s SolrConnection) search(query string) ?SolrResponse {
	url := '$s.url/$s.core/select?q=$query'

	request := http.new_request('GET', url, '') or { return error(err) }
	response := request.do() or { return error(err) }
	result := json.decode(SolrResult, response.text) or { return error(err)}
	solr_res := json.decode(SolrResponse, result.response) or { return error(err) }

	return solr_res
}

fn (s SolrConnection) add<T>(data []T) string {
	url := '$s.url/$s.core/update?commitWithin=1000&overwrite=true&wt=json'
	encoded_data := json.encode(data)

	mut request := http.new_request('POST', url, encoded_data) or { return error(err) }
	request.headers['content-type'] = 'application/json'

	response := request.do() or { return error(err)}

	return response.text
}

fn main() {
	conn := new_connection('http://localhost:8983/solr', 'vlang_core')
	res := conn.search('test_t:*') or { exit }
	println(res.docs)
}