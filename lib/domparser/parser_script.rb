Node = Struct.new :tag, :index, :attributes, :children, :parent do
  def initialize(*)
    super
    self.attributes = {}
    self.children = []
  end
end

class DOMReader
  TAG_COMMON = /<[^>]*>/
  TAG_OPEN  = /<(\w+)[^>]*>/
  TAG_CLOSE = /<\/(\w+)[^>]*>/
  TAG_ATTR  = /(\S+)=["']?((?:.(?!["']?\s+(?:\S+)=|[>"']))+.)["']?/
  TAG_TEXT  = />([^<>]*)</

  def initialize
    @stack = []
    @html = nil
    @index = 0
    @num_nodes = 1
    @root = nil
    @tag_count = 0
  end

  def parser_script file_path
    read_file file_path
    loop do
      cur_node = get_new_tag @html, @index
      # Point the root to the very first node.
      # The root property will change as the node grows.
      @root = cur_node if @root.nil?
      # Main purpose of the processing is to add connections between nodes
      # And increment the @index with each run
      processing cur_node
      break if @stack.empty?
      break if doctype?(@stack.last) && @tag_count > 1
    end
    # puts @root
    @root
  end


  # Function: Get the next tag, index property will change for each run.
  def get_new_tag html_string, index
    # Get the <Matchdata: ...>
    new_tag = html_string[index..-1].match(TAG_COMMON)
    # If find the match, get the string form from the original Matchdata
    new_tag = new_tag[0] unless new_tag.nil?
    # Get the offset of the position of the tag(beginning)
    tag_offset = html_string[index..-1] =~ TAG_COMMON
    # Create the new node of the tag
    @tag_count += 1 # The tag_count is only for determination of the loop end
    new_node = Node.new(new_tag, tag_offset)
  end

  # Just read the file and strip off all the annoying \n
  def read_file file_path
    @html = File.read(file_path).gsub("\n", "")
  end

  # Seperate process the doctype, open_tag, and close_tag
  def processing node
    if doctype? node
      process_doctype node
    elsif opentag? node
      process_opentag node
    else
      process_closetag node
    end
  end

  # For the doctype, just put it into the stack
  def process_doctype node
    add_to_stack node
    increment_index node
  end

  # For the open tag
  # Setup the parent-child connection with last element in stack
  def process_opentag node
    @stack.last.children << node
    node.parent = @stack.last
    add_attributes node
    add_to_stack node
    increment_index node
  end

  def add_attributes node
    tag_string = node.tag
    tag_length = tag_string.length
    attributes = tag_string.scan(TAG_ATTR) # Here I use the scan instead of match to get all attributes
    unless attributes.nil?
      attributes.each do |attribute|
        name = attribute[0]
        value = attribute[1]
        node.attributes[name] = value
      end
    end
  end

  # If find a close tag, the last element in the stack must be a match to it.
  # So we pop the last element in the stack.
  # Then setup the relationship with the new last element in the stack.
  def process_closetag node
    @stack.pop
    @stack.last.children << node
    node.parent = @stack.last
    increment_index node
  end

  # Small helper methods
  def add_to_stack node
    @stack << node
  end

  def increment_index node
    @index += node.tag.length + node.index
  end

  def doctype? node
    node.tag == '<!doctype html>'
  end

  def opentag? node
    !!node.tag.match(TAG_OPEN)
  end

end
