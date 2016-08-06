require 'domparser/parser_script'

describe DOMReader do
  let(:html_string){ File.read('lib/domparser/test.html').gsub("\n", "") }
  let(:file_path){ 'lib/domparser/test.html' }
  let(:new_dom){ DOMReader.new }

  context '#get new tag' do
    it 'creates a new node' do
      node = new_dom.get_new_tag(html_string, 0)
      expect(node.tag).to eq('<!doctype html>')
    end
  end

  context '#parser_script' do
    it 'turns all the tags into structure' do
      result = new_dom.parser_script file_path
      # expect(result.children[0].tag).to eq('<html>')
      # expect(result.children[1].tag).to eq('</html>')
      # expect(result.children[0].children[0].tag).to eq('<head>')
      # expect(result.children[0].children[1].tag).to eq('</head>')
      expect(result.children[0].children[2].children[0].tag).to eq('<div class="top-div">')
      # expect(result.children[0].children[3].tag).to eq('</body>')
    end

    it 'set proper tag attributes' do
      result = new_dom.parser_script file_path
      attribute_value = result.children[0].children[2].attributes[:class]
      expect(attribute_value).to eq(['one', 'two', 'three'])
    end
  end


end
