class Tag
  # To change this template use File | Settings | File Templates
  attr_accessor :toptags
  attr_accessor :tagsIdHash

  def initialize
    tags = Book.select("tags")

    tagsHash = Hash.new
    #根据每个tags的次数做统计
    tags.each do |t|
      t[:tags].to_s.split.each do |tag|
        unless tagsHash.has_key?(tag)
        then  tagsHash.store(tag,0)
        end
        tagsHash[tag] = tagsHash[tag] + 1
      end
    end

    @tagsIdHash = Hash.new
    tagandids = Book.select("id,tags")
    tagandids.each do |t|
      t[:tags].to_s.split.each do |tag|
        unless tagsIdHash.has_key?(tag)
        then  tagsIdHash.store(tag,[0])
        end
        tagsIdHash[tag][0] = tagsIdHash[tag][0] + 1
        tagsIdHash[tag] << t[:id].to_i
      end
    end

    @toptags = Hash[tagsHash.sort_by{|k,v| -v}.first 10].keys


  end

  @@instance = Tag.new

  def self.instance
    return @@instance
  end

  private_class_method :new
end