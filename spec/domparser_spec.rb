require 'spec_helper'

describe Domparser do
  let(:file_path){ 'lib/domparser/test.html' }
  let(:tree){ DOMReader.new.parser_script file_path }
  let(:new_tree){ NodeRenderer.new(tree) }
  context '#domparser' do
    it 'output all the tree nicely' do
      Domparser.parser file_path
    end

    it 'rebuild data' do
      Domparser.rebuild tree
    end
  end

end
