require 'spec_helper'

describe NodeRenderer do
  let(:file_path){ 'lib/domparser/test.html' }
  let(:tree){ DOMReader.new.parser_script file_path }
  let(:new_search){ TreeSearcher.new(tree) }
  let(:new_render){ NodeRenderer.new(tree) }
  context '#search_all' do
    it 'find proper node' do
      nodes = new_search.search_by(:id, "main-area")
      nodes.each { |node| new_render.render(node) }
    end

    it 'find proper node according to class value' do
      nodes = new_search.search_by(:class, "test")
      nodes.each { |node| new_render.render(node) }
    end

    it 'find ancestor attributes' do
      nodes = new_search.search_by(:class, "test")
      node = nodes[1]
      new_render.render(node)
      results = new_search.search_ancestors(node, :id, "main-area")
      results.each { |node| new_render.render(node) }
    end
  end

end
