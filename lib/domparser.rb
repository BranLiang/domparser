require "domparser/version"
require "domparser/node_renderer"
require "domparser/parser_script"
require "domparser/tree_searcher"

module Domparser
  def self.parser file_path
    new_dom = DOMReader.new
    tree = new_dom.parser_script file_path
    new_render = NodeRenderer.new(tree)
    new_render.render
    return tree
  end

  def self.rebuild data
    new_dom = DOMReader.new
    new_dom.simple_print_parser data
  end
  #
  def self.search data, attr_name, attr_value
    new_search = TreeSearcher.new(data)
    new_search.search_descendents data, attr_name, attr_value
  end

end
