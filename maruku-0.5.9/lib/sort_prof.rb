
field = (ARGV.shift or '2').to_i

lines = $stdin.read.split("\n")
# leave the first lines

while l = lines.shift
	puts l
	break if l =~ /total/
end




puts lines.sort {|a,b| 
	a.split[field].to_f <=> b.split[field].to_f
}.reverse.join("\n")
	
	
	


