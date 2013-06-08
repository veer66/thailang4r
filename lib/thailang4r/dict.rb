module ThaiLang
  class Dict
    def initialize(file_path)
      load_dict(file_path)
    end
    
    def load_dict(file_path)      
      File.open(file_path) do |f|
        @str_list = f.readlines.map{|line| line.chomp}
      end
    end
    
    def find_first_index_of_needle(prefix, offset = nil, s = nil, e = nil)
      find_index_of_needle(:FIRST, prefix, offset, s, e)
    end
    
    def find_last_index_of_needle(prefix, offset = nil, s = nil, e = nil)
      find_index_of_needle(:LAST, prefix, offset, s, e)
    end
    
    def find_index_of_needle(pos_type, prefix, offset = nil, s = nil, e = nil) 
  		offset = offset.nil? ? 0 : offset
  		s = s.nil? ? 0 : s
      e = e.nil? ? @str_list.length : e
      
      l = s
      r = e - 1;
      ans = nil

  		while l <= r do
  			m = (l + r) / 2 
  			ch = @str_list[m][offset]
  			if ch.nil? or prefix > ch
  			  l = m + 1
  			elsif prefix < ch
  			  r = m - 1
  			else
  			  ans = m
  			  if pos_type == :FIRST
  			    r = m - 1
  			  else
  			    l = m + 1
  			  end
  			end
  		end
  			
  		ans
  	end
  	
  	def size
  	  @str_list.length
	  end
	  
	  def [](i)
	    @str_list[i]
    end
  end
  
  class DictIter
    def initialize(dict)
      @dict = dict
      @e = @dict.size
      @s = 0
      @state = :ACTIVE
      @offset = 0
    end
  
    def walk(ch) 
      if @state != :INVALID
        first = @dict.find_first_index_of_needle ch, @offset, @s, @e
        if first.nil?
          @state = :INVALID
        else
          @s = first
          last = @dict.find_last_index_of_needle ch, @offset, @s, @e
          @e = last + 1
          len = @dict[first].length
          @offset += 1
          if(@offset == len)
            @state = :ACTIVE_BOUNDARY
          else
            @state = :ACTIVE
          end
        end
      end
      @state
    end  	
  end
end