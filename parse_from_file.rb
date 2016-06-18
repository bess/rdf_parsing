# Following tutorial at http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby

require 'rdf'
require 'rdf/raptor'
require 'sparql'
require 'net/http'
require 'openssl'

# RDF::Reader.open("foaf_files/foaf.rdf") do |reader|
#   reader.each_statement do |statement|
#     puts statement.inspect
#   end
# end

graph = RDF::Graph.load("foaf_files/foaf.rdf")

# puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT *
  WHERE { ?s foaf:knows ?o }
"

# queryable = RDF::Repository.load("foaf_files/foaf.rdf")
bess_rdf = RDF::Resource(RDF::URI.new("http://stanford.edu/~bess/foaf.rdf"))
hacker_nt = RDF::Resource(RDF::URI.new("http://datagraph.org/jhacker/foaf.nt"))

# Load multiple RDF files into the same RDF::Repository object
queryable = RDF::Repository.load(hacker_nt)
queryable.load(bess_rdf)

sse = SPARQL.parse(query)
sse.execute(queryable) do |result|
  puts result.o
end
