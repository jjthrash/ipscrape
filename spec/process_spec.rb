require 'lib/process'

def doc_for_string(string)
    Nokogiri::HTML(string)
end

describe "all_text_content" do
    it "should return all text content" do
        doc = doc_for_string <<-END
<html><body><p><b>Junk and stuff</b></p></body></html>
        END

        all_text_content(doc.xpath('//body')[0]).should have(1).item
    end
end

describe "process_table" do
    it "should parse a basic table into rows with columns" do
        doc = doc_for_string <<-END
<html>
<body>
<table>
<tr>
    <td>1</td>
    <td>2</td>
</tr>
<tr>
    <td><b>3</b></td>
    <td>4</td>
    <td>5</td>
</tr>
</table>
</body>
</html>
        END

        results = process_table(doc.xpath('//table')[0])
        results.should have(2).items
        results[0].should have(2).items
        results[1].should have(3).items
        results[0][1].name.should == 'td'
    end
end

describe "table_to_text" do
    it "should be able to turn a table into its text nodes" do
        doc = doc_for_string <<-END
<html>
<body>
<table>
<tr>
    <td>1</td>
    <td>2</td>
</tr>
<tr>
    <td><b>3</b></td>
    <td>4</td>
    <td>5</td>
</tr>
</table>
</body>
</html>
        END

        results = table_to_text(doc.xpath('//table')[0])
        results.should == [
            ['1','2'],
            ['3','4','5'],
        ]
    end
end

describe "table_to_csv" do
    it "should convert a simple table into csv" do
        result = to_csv([['1','2','3'],['4','5']])
        result.should == "1,2,3\n4,5"
    end
end
