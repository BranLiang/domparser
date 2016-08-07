require 'spec_helper'

describe DOMReader do
  let(:html_string){ File.read('lib/domparser/test.html').gsub("\n", "") }
  let(:file_path){ 'lib/domparser/test.html' }
  let(:file_path2){ 'lib/domparser/test2.html' }
  let(:new_dom){ DOMReader.new }

  context '#parser_script' do
    it 'turns all the tags into structure' do
      result = new_dom.parser_script file_path
      expect(result.children[0].tag).to eq('<html>')
      expect(result.children[0].children[2].children[0].tag).to eq('<div class="top-div test test2">')
    end

    it 'set proper tag attributes' do
      result = new_dom.parser_script file_path
      expect(result.children[0].children[2].children[0].attributes[:class]).to eq(["top-div", 'test', 'test2'])
    end

    it 'set proper text' do
      result = new_dom.parser_script file_path
      expect(result.children[0].children[0].children[0].children[0].tag).to eq('This is a test page')
    end
  end

  context '#print_parser' do
    it 'simple_print_parser' do
      result = new_dom.parser_script file_path
      new_dom.simple_print_parser result
    end

    # it 'simple_print_parser for test2' do
    #   result = new_dom.parser_script file_path2
    #   new_dom.simple_print_parser result
    # end
  end


end
