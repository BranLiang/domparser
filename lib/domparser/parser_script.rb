Node = Struct.new :tag, :offset, :type, :attributes, :children, :parent do
  def initialize(*)
    super
    self.attributes = {}
    self.children = []
  end
end

class DOMReader
  attr_accessor :root, :tag_count

  TAG_COMMON = /<[\/]*(\w+)[^>]*>/  # Include both open and close tag conditions, <!doctype> is exclude here.
  TAG_OPEN  = /<(\w+)[^>]*>/
  TAG_CLOSE = /<\/(\w+)[^>]*>/
  TAG_ATTR  = /(\S+)=["']?((?:.(?!["']?\s+(?:\S+)=|[>"']))+.)["']?/
  TAG_TEXT  = />([^<>]*[\w\d]+[^<>]*)</
  TAG_SPECIAL = /(<img[^>]*>|<hr[^>]*>|<area[^>]*>|<base[^>]*>|<br[^>]*>|<col[^>]*>|<embed[^>]*>|<input[^>]*>|<link[^>]*>|<meta[^>]*>|<source[^>]*>|<param[^>]*>|<command[^>]*>|<track[^>]*>|<keygen[^>]*>|<wbr[^>]*>)/

  # @Stack is only used to store open tag. Because only opentags can have children
  # @Stack will be initialized with the DOCUMENT node
  # @html is used to store html
  # @index is used to store tag offset
  # @root is the tag tree
  # @tag_count counts the opentag + specialtag + texttag
  def initialize
    @stack = []
    @html = nil
    @index = 0
    @root = Node.new('DOCUMENT', nil, 'general', 0)
    @tag_count = 0
  end

  # Get new node, do proper process depends on its type, weather its opentag,
  # close tag or special tag.
  # Break the loop if the stack has one element left
  def parser_script file_path
    read_file file_path
    @stack << @root # initialize the @stack
    loop do
      cur_node = get_new_tag @html, @index
      processing cur_node
      break if @stack.length == 1
    end
    @root
  end

  # Recursively print all the tags in the data structure.
  # Simple cheat print, only use the tag in the data structure.
  def simple_print_parser data
    puts data.tag
    return if data.children.empty?
    data.children.each do |child|
      simple_print_parser child
    end
  end

  private

  # Function: Get the next tag, index property will change for each run.
  # Get the <Matchdata: ...>
  # If find the match, get the string form from the original Matchdata
  # Get the offset of the position of the tag(beginning)
  # Create the new node of the tag
  def get_new_tag html_string, index
    new_tag = html_string[index..-1].match(TAG_COMMON)
    new_tag = new_tag[0] unless new_tag.nil?
    tag_offset = html_string[index..-1] =~ TAG_COMMON
    new_node = Node.new(new_tag, tag_offset)
  end

  # Just read the file and strip off all the annoying \n
  def read_file file_path
    @html = File.read(file_path).gsub("\n", "")
  end

  # Seperate process the open_tag, close_tag and special tag
  def processing node
    if special? node
      process_special node
    elsif opentag? node
      process_opentag node
    else
      process_closetag node
    end
  end

  # For special tag, add its previews text and setup relationship, add its type
  # and attributes


  def process_special node
    add_text node
    setup_relation node
    add_tag_type node
    add_attributes node
    increment_index node
    @tag_count += 1
  end


  # For the open tag
  # Setup the parent-child connection with last element in stack
  def process_opentag node
    process_special node
    add_to_stack node
  end

  # If find a close tag, the last element in the stack must be a match to it.
  # So we pop the last element in the stack.
  # Then setup the relationship with the new last element in the stack.
  # The add text step must be done before the @stack.pop so the text is connected to the previews open tag
  def process_closetag node
    add_text node
    @stack.pop
    setup_relation node
    increment_index node
  end

  def add_text node
    text_match = @html[(@index - 1)..(@index + node.offset + 1)].match(TAG_TEXT)
    unless text_match.nil?
      text = text_match[1].strip
      t_node = Node.new(text, nil, 'text')
      setup_relation t_node
      @tag_count += 1
    end
  end

  def add_attributes node
    attributes = node.tag.scan(TAG_ATTR) # Here I use the scan instead of match to get all attributes
    unless attributes.nil?
      attributes.each do |attribute|
        attribute[0] == "class" ? set_class_attr(attribute, node) : set_normal_attr(attribute, node)
      end
    end
  end

  def set_class_attr attribute, node
    node.attributes[:class] = []
    classes = attribute[1]
    classes.split(" ").each do |one_class|
      node.attributes[:class] << one_class.strip
    end
  end

  def set_normal_attr attribute, node
    name = attribute[0].to_sym # transform it to symbol
    value = attribute[1]
    node.attributes[name] = value
  end


  # Small helper methods
  def setup_relation node
    @stack.last.children << node
    node.parent = @stack.last
  end

  def add_tag_type node
    node.type = node.tag.match(TAG_OPEN)[1].to_sym
  end

  def add_to_stack node
    @stack << node
  end

  def increment_index node
    @index += node.tag.length + node.offset
  end

  def opentag? node
    !!node.tag.match(TAG_OPEN)
  end

  def special? node
    !!node.tag.match(TAG_SPECIAL)
  end

end
