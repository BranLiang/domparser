require 'domparser/tagparser'

describe '#parse_tag' do
  it 'return the id, type, classes test set1' do
    string = "<p class ='foo bar' id='baz' name='fozzie'>"
    result = parse_tag string
    expect(result.id).to eq("baz")
    expect(result.type).to eq("p")
    expect(result.classes).to eq(['foo', 'bar'])
    expect(result.name).to eq('fozzie')
  end

  it 'return the id, type, classes test set2' do
    string = "<div id = ' bim'>"
    result = parse_tag string
    expect(result.id).to eq("bim")
    expect(result.type).to eq("div")
  end

  it 'return the type, src, title test set3' do
    string = "<img src='http://www.example.com' title='funny things'>"
    result = parse_tag string
    expect(result.title).to eq('funny things')
    expect(result.src).to eq('http://www.example.com')
    expect(result.type).to eq('img')
  end
end
