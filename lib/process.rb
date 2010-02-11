require 'rubygems'
require 'nokogiri'

def all_text_content(node)
    node.children.collect {|c|
        if c.instance_of?(Nokogiri::XML::Text)
            c.content
        else
            all_text_content(c)
        end
    }.flatten
end

def process_table(table_node)
    table_node.children.select {|child|
        child.instance_of?(Nokogiri::XML::Element) && child.name == 'tr'
    }.collect { |tr|
        tr.xpath('td')
    }
end

def table_to_text(table)
    processed = process_table(table).collect {|row|
        row.collect {|col|
            all_text_content(col).collect {|c| c.strip}.join('')
        }
    }
end

def table_to_csv(table)
    to_csv(table_to_text(table))
end

def process(text)
    table_to_csv(Nokogiri::HTML(text).xpath('//form[@name="outerform1"]/table'))
end

def to_csv(rows)
    rows.collect { |row|
        row.join(',')
    }.join("\n")
end

if __FILE__ == $0
    puts process(open(ARGV[0]))
end
