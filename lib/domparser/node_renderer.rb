class NodeRenderer
  def initialize tree
    @tree = tree
    @type_hash = nil
    @general_hash = nil
  end

  def render node = nil
    if node.nil?
      @general_hash = Hash.new(0)
      @type_hash = Hash.new(0)
      detail_print_all @tree
      general_print_all @tree
      print_general_hash @general_hash
      detail_print_hash @type_hash
    end
  end

  def general_print_all data
    @general_hash[data.type] += 1 unless data.type.nil?
    return if data.children.empty?
    data.children.each do |child|
      general_print_all child
    end
  end

  def print_general_hash hash
    hash.each do |type, value|
      puts "|#{type.to_s.center(8)} : #{value.to_s.center(4)}|"
    end
    puts "*" * 100
  end

  def detail_print_hash hash
    hash.each do |key, type_count|
      key.each do |type, attributes|
        if attributes.empty?
          puts "#{type_count} #{type}"
          puts "-" * 100
        else
          puts "#{type_count} #{type} with following attributes:"
          attributes.each do |attr_name, attr_value|
            puts "    #{attr_name} : #{attr_value}"
          end
          puts "-" * 100
        end
      end
    end
  end

  def detail_print_all data
    unless data.type.nil?
      type_hash = {}
      type_hash[data.type] = data.attributes
      @type_hash[type_hash] += 1
    end
    return if data.children.empty?
    data.children.each do |child|
      detail_print_all child
    end
  end
end
