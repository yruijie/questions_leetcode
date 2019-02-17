# encoding: UTF-8
require "fileutils"


MY_PATH = './Questions1-710'



def traverse()
	Dir.glob("#{MY_PATH}/**/*").each do |name|
		unless File.directory?(name)
			process_file(name)
		end # end unless
	end # end Dir.glob
end # end function traverse()

def process_file(name)
	basename = File.basename(name, ".html")
	filename = File.basename(name)
	num = $num_name_hash[basename]
  print basename, '--', num,"\n" if num

	FileUtils.mv(MY_PATH+'/'+filename, MY_PATH+'/'+num.to_s + '-' + filename) if num
end

def gen_updated_file(path)
	File.open(path + ".bak0") do |io|
		File.open(path, "w") do |output|
			io.each_line do |line|
				line.chomp!
				if /(grant|revoke)\s*sysadm/i =~ line
					output.puts(line)
				else
					output.puts(line.gsub(/SYSADM|ADMF001/i,GET_TSO_ID)
					.gsub(/STLEC1B/i, GET_DB2_ID2).gsub(/STLEC1/i, GET_DB2_ID))
				end
			end
		end # File.open in w mode
	end	# File.open
end # func gen_updated_file

def backup_old_file(path)
	FileUtils.mv(path, path + ".bak0")
end


def sync_to_RFTworkspace(path)
	FileUtils.mv(path, path.sub('C:/YRJ','C:/RFTworkspace/AdminOCProj/db2admin') )
end





# 1) Read the question_list, create the Hash: key is title, value is number
# 2) Traverse in the directory, read the file name, get the number according to
# file name as the key.
# 3) Rename the file name: new is number+basename
$num_name_hash = {}
def init_hash(file_path)
	File.open(file_path, 'r') do |io|
		io.each_line do |line|
			line.chomp!
			ary = line.split('_')
			$num_name_hash[ary[1]] = ary[0]
		end
	end
end

init_hash("problem_list")
traverse()
