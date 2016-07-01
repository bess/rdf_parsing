require 'rdf'
require 'linkeddata'

# 1. Load my own FOAF file
graph = RDF::Graph.load("foaf_files/foaf.rdf")
puts graph.inspect

# 2. Find everyone I know

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT *
  WHERE { ?s foaf:knows ?o }
"

# 3. Load all of their FOAF files into the same graph as mine

puts "before loading"
sse = SPARQL.parse(query)
sse.execute(graph) do |result|
  puts result.o
  graph.load(result.o)
end

puts "after loading"
sse.execute(graph) do |result|
  puts result.o
end

# 4. Write the new graph out to a file in turtle
# file endings to try: rdf, ttl, nt

RDF::Writer.open("output.ttl") do |writer|
  graph.each_statement do |statement|
    writer << statement
  end
end

# Add and delete statements. Go through this tutorial: http://blog.datagraph.org/2010/03/rdf-for-ruby

# 5. Remove all the "error reports to" statements
graph.delete([rdfrb, RDF::DC.creator, arto])
