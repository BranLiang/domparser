require 'spec_helper'

describe NodeRenderer do
  let(:file_path){ 'lib/domparser/test.html' }
  let(:tree){ DOMReader.new.parser_script file_path }
  let(:new_tree){ NodeRenderer.new(tree) }
  context '#print_all' do
    it 'output all the tree nicely' do
      new_tree.render
    end
  end
end
