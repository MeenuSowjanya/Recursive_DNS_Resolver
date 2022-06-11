
def get_command_line_argument

    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end

    ARGV.first
    
end

domain = get_command_line_argument

dns_raw = File.readlines("zone")

def parse_dns(file)

   dns_records = { RECORD_TYPE: [] , SOURCE: [] , DESTINATION: [] }

   for i in (file.select {|x| (x[0] != "#") && (x != "\n")})

      dns_records[:RECORD_TYPE].push((i.split(","))[0].strip())
      dns_records[:SOURCE].push((i.split(","))[1].strip())
      dns_records[:DESTINATION].push((i.split(","))[2].strip())

   end

   return dns_records

end

def resolve( source_hash , result_array , domain_name )

    if (source_hash[:SOURCE].include? domain_name)

        index = (source_hash[:SOURCE]).find_index(domain_name)

        if ((source_hash[:RECORD_TYPE][index]) == "A")
         result_array.push((source_hash[:DESTINATION])[index])

        elsif ((source_hash[:RECORD_TYPE][index]) == "CNAME")
         new_domain_name = (source_hash[:DESTINATION])[index]
         resolve( source_hash , result_array , new_domain_name )

       else       
        result_array.push("Oops! Sorry.. This domain name does not exist in the zone file")

       end

    end

    return result_array

end

dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")