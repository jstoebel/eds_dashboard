class Sheet
    # a mock of a Roo sheet object

    def initialize(arr)
      # arr: a 2D array
      @arr = arr
    end

    def count
      # get number of rows
      return @arr.size
    end

    def row(idx)
      # index of row to find (starts at 1)
      return @arr[idx-1]
    end

    def cell(row, col)
      # cell to find (both values starts at 1)
      return @arr[row-1][col-1]
    end

    def each_with_index
      i = 0
      while i < @arr.size
        yield([@arr[i], i])
        i += 1
      end

    end

end
