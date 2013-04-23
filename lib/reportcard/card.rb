module ReportCard
  
  class Util
    
    def Util.void_for_dataset(url)
      repository = RDF::Repository.load(url)
      return repository      
    end
        
    def Util.classes_for_dataset(url)
      repository = Util.void_for_dataset(url)
      classes = {}
      repository.query( [ nil, RDF::URI.new("http://rdfs.org/ns/void#classPartition"), nil ] ) do |classStatement|
        repository.query( [ classStatement.object, RDF::URI.new("http://rdfs.org/ns/void#class"), nil ] ) do |statement|
          uri = statement.object.to_s
          count = repository.first_literal( [classStatement.object, RDF::URI.new("http://rdfs.org/ns/void#entities"), nil] ).value
          classes[uri] = count
        end        
      end  
      return classes    
    end
    
#    def Util.collate_void(urls)
#      hydra = Typhoeus::Hydra.new        
#      repository = RDF::Repository.new
#      urls.each do |url|
#        req = Typhoeus::Request.new(url, :headers => {"Accept" => "text/turtle"} )        
#        #on complete parse the response
#        req.on_complete do |r|
#          if r.code == 200
#            data = StringIO.new(r.body)
#            begin
#              RDF::Reader.for(:turtle).new(data) do |reader|
#                reader.each_statement do |statement|
#                  repository << statement
#                end
#              end             
#            rescue StandardError => e
#              $stderr.puts "Failed to parse #{url}"
#              $stderr.puts e
#              $stderr.puts e.backtrace
#            end
#          else
#            $stderr.puts "Response of #{r.code} from #{url}"
#            $stderr.puts r.curl_error_message
#          end      
#   
#        end        
#        hydra.queue(req)            
#      end    
#      hydra.run
#      return repository    
#    end
      
  end
end