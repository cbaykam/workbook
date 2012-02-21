require 'test/helper'

class TestRow < Test::Unit::TestCase

  
  def test_init
    t = Workbook::Table.new
    r = Workbook::Row.new([1,2,3],t)
    c1 = Workbook::Cell.new(1)
    c2 = Workbook::Cell.new(2)
    c3 = Workbook::Cell.new(3)
    assert_equal([c1,c2,c3].collect{|c| c.value},r.collect{|c| c.value})
    
    #t = Workbook::Table.new
    c1 = Workbook::Cell.new(1)
    c2 = Workbook::Cell.new(2)
    c3 = Workbook::Cell.new(3)
    
    r = Workbook::Row.new([c1,c2,c3])

    assert_equal([c1,c2,c3],r)
    
  end
  
  def test_table=
    r = Workbook::Row.new
    assert_raise(ArgumentError, 'table should be a Workbook::Table (you passed a String)') { r.table = "asdf" }
    r.table = nil
    assert_equal(r.table, nil)
    r = Workbook::Row.new
    
    t = Workbook::Table.new
    r.table = t
    assert_equal(r.table, t)
  end

  def test_header?
    t = Workbook::Table.new
    r1 = Workbook::Row.new
    r1.table = t
    assert_equal(true, r1.header?)
    r2 = Workbook::Row.new
    r2.table = t
    assert_equal(false, r2.header?)
    r2 = Workbook::Row.new
    r2.table = t
    assert_equal(false, r2.header?)
    assert_equal(true, t.first.header?)
    assert_equal(r1, t.first)    
  end 
  
  def test_to_symbols
    r1 = Workbook::Row.new ["test", "asdf-asd", "asdf - asdf", "asdf2"]
    assert_equal([:test, :asdfasd, :asdf_asdf, :asdf2], r1.to_symbols)
  end
  
  def test_to_hash
    r1 = Workbook::Row.new ["test", "asdf-asd", "asdf - asdf", "asdf2"]
    assert_raise(NoMethodError, 'undefined method `header\' for nil:NilClass') { r1.to_hash }
    
    t = Workbook::Table.new
    r1 = Workbook::Row.new  ["test", "asdf-asd"]
    r1.table = t
    expected = {:test=>Workbook::Cell.new("test"), :asdfasd=>Workbook::Cell.new("asdf-asd")}
    assert_equal(expected, r1.to_hash)
    date = DateTime.now
    r2 = Workbook::Row.new  [2, date]
    r2.table = t
    expected = {:test=>Workbook::Cell.new(2), :asdfasd=>Workbook::Cell.new(date)}
    assert_equal(expected, r2.to_hash)
    assert_equal(date, r2[:asdfasd].value)
    assert_equal(date, r2[1].value)
  end
  
  def test_compare
    r1 = Workbook::Row.new  ["test", "asdf-asd"]
    r2 = Workbook::Row.new  [nil, "asdf-asd"]
    assert_equal(-1,r1<=>r2)
    r1 = Workbook::Row.new  [1, "asdf-asd"]
    r2 = Workbook::Row.new  ["test", "asdf-asd"]
    assert_equal(-1,r1<=>r2)
    r1 = Workbook::Row.new  [nil, "asdf-asd"]
    r2 = Workbook::Row.new  [Time.now, "asdf-asd"]
    assert_equal(1,r1<=>r2)
    r1 = Workbook::Row.new  [2, 3]
    r2 = Workbook::Row.new  [2, nil]
    assert_equal(-1,r1<=>r2)
    r1 = Workbook::Row.new  [3, 0]
    r2 = Workbook::Row.new  [2, 100000]
    assert_equal(1,r1<=>r2)
    r1 = Workbook::Row.new  [-10, 3]
    r2 = Workbook::Row.new  [nil, 5]
    assert_equal(-1,r1<=>r2)
    
  end
  
  def test_find_cells_by_background_color
    r = Workbook::Row.new  ["test", "asdf-asd"]
    assert_equal([],r.find_cells_by_background_color)
    f = Workbook::Format.new
    f[:background_color]='#ff00ff'
    r.first.format = f
    assert_equal([:test],r.find_cells_by_background_color)
    assert_equal([],r.find_cells_by_background_color('#ff0000'))
  end
end