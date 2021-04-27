# coding: utf-8

module ThaiLang
  NODE_KEY_ROW_NO = 0
  NODE_KEY_OFFSET = 1
  NODE_KEY_CH = 2

  NODE_PTR_ROW_NO = 0
  NODE_PTR_IS_FINAL = 1
  NODE_PTR_PAYLOAD = 2

  NodeKey = Struct.new(:row_no, :offset, :ch)

  class PrefixTree
    def initialize(sorted_words_with_payload)
      @prefix_tree = {}
      sorted_words_with_payload.each.with_index do |(w, payload), i|
        row_no = 0
        ch_vec = w.codepoints
        ch_len = w.length
        ch_vec.each.with_index do |ch, j|
          node_key = NodeKey.new(row_no, j, ch)
          ex_node_ptr = @prefix_tree[node_key]
          if ex_node_ptr
            row_no = ex_node_ptr[NODE_PTR_ROW_NO]
          else
            is_final = (j + 1 == ch_len)
            node_ptr = [i, is_final, if is_final; payload; end]
            @prefix_tree[node_key] = node_ptr
            row_no = i
          end
        end
      end
    end
    
    def lookup(row_id, offset, ch)
      @prefix_tree[NodeKey.new(row_id, offset, ch)]
    end
  end



  class WordBreaker
    def initialize(dix_path = nil)
      dix_path = File.expand_path('../../../data/tdict-std.txt', __FILE__) unless dix_path
      @dix = PrefixTree.new(File.open(dix_path).each_line.map { [_1.chomp, 1] })
    end

    def break_into_words(text)
      tokenize(@dix, text)
    end
    
    UNK   = 1
    DICT  = 2
    INIT  = 3
    LATIN = 4
    PUNC  = 5
    
    LINK_P_IDX = 0
    LINK_W     = 1
    LINK_UNK   = 2
    LINK_KIND  = 3
    
    def better_link?(l, r)
      l[LINK_UNK] < r[LINK_UNK] or l[LINK_W] < r[LINK_W]
    end
    
    WAITING    = 1
    ACTIVATED  = 2
    COMPLETED  = 3
    
    CAP_A = "A".ord
    CAP_Z = "Z".ord
    A = "a".ord
    Z = "z".ord
    
    def latin?(ch)
      (ch >= CAP_A and ch <= CAP_Z) or (ch >= A and ch <= Z)
    end
    
    TRANSDUCER_S     = 0
    TRANSDUCER_E     = 1
    TRANSDUCER_STATE = 3
    TRANSDUCER_KIND  = 4
    
    def update_latin_transducer(transducer, ch, i, ch_vec)
      if transducer[TRANSDUCER_STATE] == WAITING
        if latin?(ch)
          transducer[TRANSDUCER_S] = i
          transducer[TRANSDUCER_STATE] = ACTIVATED
          if i + 1 == ch_vec.length or not latin?(ch_vec[i + 1])
            transducer[TRANSDUCER_E] = i + 1
            transducer[TRANSDUCER_STATE] = COMPLETED
          end
        end
      else
        if latin?(ch)
          transducer[TRANSDUCER_E] = i + 1
          transducer[TRANSDUCER_STATE] = COMPLETED      
        else
          transducer[TRANSDUCER_STATE] = WAITING
        end
      end
    end
    
    
    SPACE = " ".ord

    def punc?(ch)
      ch == SPACE
    end
    
    def update_punc_transducer(transducer, ch, i, ch_vec)
      if transducer[TRANSDUCER_STATE] == WAITING
        if punc?(ch)
          transducer[TRANSDUCER_S] = i
          transducer[TRANSDUCER_STATE] = ACTIVATED
          if i + 1 == ch_vec.length or not punc?(ch_vec[i + 1])
            transducer[TRANSDUCER_E] = i + 1
            transducer[TRANSDUCER_STATE] = COMPLETED
          end
        end
      else
        if punc?(ch)
          transducer[TRANSDUCER_E] = i + 1
          transducer[TRANSDUCER_STATE] = COMPLETED      
        else
          transducer[TRANSDUCER_STATE] = WAITING
        end
      end
    end

    DIX_PTR_S        = 0
    DIX_PTR_ROW_NO   = 1
    DIX_PTR_IS_FINAL = 2
    
    def build_path(dix, s)
      left_boundary = 0
      ch_vec = s.codepoints
      ch_len = ch_vec.length
      path = [[0,0,0,INIT]]
      dix_ptrs = []
      latin_transducer = [0,0,WAITING,LATIN]
      punc_transducer =[0,0,WAITING,PUNC]
      ch_vec.each.with_index do |ch, i|
        dix_ptrs << [i, 0, false]
        unk_link = path[left_boundary]
        link = [left_boundary, unk_link[LINK_W] + 1, unk_link[LINK_UNK] + 1, UNK]
        j = 0
        while j < dix_ptrs.length
          dix_ptr = dix_ptrs[j]
          offset = i - dix_ptr[DIX_PTR_S]
          row_no = dix_ptr[DIX_PTR_ROW_NO]
          child = dix.lookup(row_no, offset, ch)
          #      puts "ch:#{ch} offset:#{offset} rowno:#{row_no} child:#{child}"
          if child
            dix_ptrs[j] = [dix_ptr[DIX_PTR_S], child[NODE_PTR_ROW_NO], child[NODE_PTR_IS_FINAL]]
            j += 1
          else
            unless j + 1 == dix_ptrs.length
              dix_ptrs[j] = dix_ptrs.pop
            else
              dix_ptrs.pop
            end
          end
        end
        
        update_latin_transducer(latin_transducer, ch, i, ch_vec)
        update_punc_transducer(punc_transducer, ch, i, ch_vec)
        
        dix_ptrs.each do |dix_ptr|
          if dix_ptr[DIX_PTR_IS_FINAL]
            new_s = dix_ptr[DIX_PTR_S]
            #        puts "NEW_S:#{new_s} DIX-PTR:#{dix_ptr} i:#{i}"
            prev_link = path[new_s]
            w = prev_link[LINK_W]
            unk = prev_link[LINK_UNK]
            new_link = [new_s, w + 1, unk, DICT]
            link = new_link if better_link?(new_link, link)
          end
        end
        
        if latin_transducer[TRANSDUCER_STATE] == COMPLETED
          s = latin_transducer[TRANSDUCER_S]
          prev_link = path[s]
          w = prev_link[LINK_W]
          unk = prev_link[LINK_UNK]
          new_link = [s, w + 1, unk, LATIN]
          link = new_link if better_link?(new_link, link)      
        end
        
        if punc_transducer[TRANSDUCER_STATE] == COMPLETED
          s = punc_transducer[TRANSDUCER_S]
          prev_link = path[s]
          w = prev_link[LINK_W]
          unk = prev_link[LINK_UNK]
          new_link = [s, w + 1, unk, PUNC]     
          link = new_link if better_link?(new_link, link)
        end
        left_boundary = i if link[LINK_KIND] != UNK
        path << link
      end
      path
    end

    RANGE_S = 0
    RANGE_E = 1
    
    def path_to_ranges(path)
      e = path.length - 1
      ranges = []
      while e > 0
        link = path[e]
        s = link[LINK_P_IDX]
        ranges << [s,e]
        e = s
      end
      ranges.reverse
    end
    
    def ranges_to_toks(ranges, str)
      ranges.map {|s,e| str[s...e]}
    end

    def tokenize(dix, str)
      ranges_to_toks(path_to_ranges(build_path(dix, str)), str)
    end

    def tokenize_with_delim(dix, str, delim)
      tokenize(dix, str).join(delim)
    end   
  end
end


  #dix = APrefixTree.new([["กา",1],["กาก",1]])
  #p dix
  #p tokenize_with_delim(dix, "บทความนี้ใช้ระบบคริสต์ศักราช เพราะอ้างอิงคริสต์ศักราชและคริสต์ศตวรรษ หรืออย่างใดอย่างหนึ่ง", "|")


  #t2 = [0,0,WAITING,LATIN]
  #update_punc_transducer(t2, 32, 0, [32])
  #p t2
  #t1 = PrefixTree.new([["A",1]])
  #p t1.lookup(0, 0, "A".codepoints[0])

  #t2 = [0,0,WAITING,LATIN]
  #update_punc_transducer(t2, 32, 0, [32])
  #p t2
  #t1 = PrefixTree.new([["A",1]])
  #p t1.lookup(0, 0, "A".codepoints[0])


  #word_breaker = ThaiLang::WordBreaker.new
  #puts word_breaker.break_into_words("ฉันกินข้าว")
