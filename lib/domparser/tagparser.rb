Tag = Struct.new :type, :classes, :id, :name, :title, :src, :children, :parent do
  def initialize(*)
    super
    self.children = []
  end
end

ID_PATTERN   = /id\s?=\s?['|"]([^'"]*)['|"]/
TYPE_PATTERN = /<\s?([^>\s]*)/
CLASSES_PATTERN = /class\s?=\s?['|"]([^'"]*)['|"]/
NAME_PATTERN = /name\s?=\s?['|"]([^'"]*)['|"]/
SRC_PATTERN = /src\s?=\s?['|"]([^'"]*)['|"]/
TITLE_PATTERN = /title\s?=\s?['|"]([^'"]*)['|"]/

def parse_tag string
  tag = Tag.new
  id_match =
  tag.id = parse_tag_id string
  tag.type = parse_tag_type string
  tag.name = parse_tag_name string
  tag.classes = parse_tag_classes string
  tag.src = parse_tag_src string
  tag.title = parse_tag_title string
  tag
end

def parse_tag_title string
  title_match = string.match(TITLE_PATTERN)
  return title_match.nil? ? nil : title_match[1].strip
end

def parse_tag_src string
  src_match = string.match(SRC_PATTERN)
  return src_match.nil? ? nil : src_match[1].strip
end

def parse_tag_id string
  id_match = string.match(ID_PATTERN)
  return id_match.nil? ? nil : id_match[1].strip
end

def parse_tag_type string
  type_match = string.match(TYPE_PATTERN)
  return type_match.nil? ? nil : type_match[1].strip
end

def parse_tag_name string
  name_match = string.match(NAME_PATTERN)
  return name_match.nil? ? nil : name_match[1].strip
end

def parse_tag_classes string
  class_match = string.match(CLASSES_PATTERN)
  result = []
  unless class_match.nil?
    class_string = class_match[1]
    class_string.strip.split(" ").each do |one_class|
      result << one_class.strip
    end
    return result
  end
  return nil
end
