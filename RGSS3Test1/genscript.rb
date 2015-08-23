#!/usr/bin/ruby
require "zlib"

scripts_data = []
Dir.glob("Scripts/*.rb").sort.each do|scriptfile|
  if /\AScripts\/\d\d\d_(\w+)\.rb\z/ =~ scriptfile then
    title = $1
    zscript = Zlib::Deflate::deflate(File.read(scriptfile))
    scripts_data << [rand(100000000), title, zscript]
  end
end

File.open("Data/Scripts.rvdata2", "wb") do|scriptsfile|
  Marshal.dump(scripts_data, scriptsfile)
end
