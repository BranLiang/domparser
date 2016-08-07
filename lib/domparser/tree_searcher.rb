class TreeSearcher
  def initialize tree
    @tree = tree
    @node_array = []
  end

  def search_by(attr_name, attr_value)
    result = search @tree, attr_name, attr_value
    @node_array = []
    puts result.empty? ? "No results found" : "Results found"
    result
  end

  def search_descendents(node, attr_name, attr_value)
    result = search node, attr_name, attr_value
    @node_array = []
    puts result.empty? ? "No results found" : "Results found"
    result
  end

  def search_ancestors(node, attr_name, attr_value)
    result = search_ancestor_helper node, attr_name, attr_value
    @node_array = []
    puts result.empty? ? "No results found" : "Results found"
    result
  end



  def search data, attr_name, attr_value
    collect_results data, attr_name, attr_value
    return if data.children.empty?
    data.children.each do |child|
      search child, attr_name, attr_value
    end
    @node_array
  end

  def search_ancestor_helper data, attr_name, attr_value
    collect_results data, attr_name, attr_value
    return if data.parent.nil?
    search_ancestor_helper data.parent, attr_name, attr_value
    @node_array
  end

  def collect_results data, attr_name, attr_value
    unless data.attributes.empty?
      data.attributes.each do |name, value|
        if attr_name == :class && name == :class
          @node_array << data if value.any? { |class_name| attr_value == class_name }
        else
          @node_array << data if attr_name == name && attr_value == value
        end
      end
    end
  end

end
