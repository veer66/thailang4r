module ThaiLang
  class WordDagBuilder
    def initialize(dict)
      @dict = dict
    end

    def build(string, len)
      dag = []
      _build_by_dict(dag, string, len)
      #_build_by_latin_rule(dag, string, len)
      dag.sort do |a,b|
        r = 0
        for i in 0..2
          r = a[i] <=> b[i]
          if r != 0
            break
          end
        end
        r
      end
    end

    def _build_by_latin_rule(dag, string, len)
      next_latin = 0
      for i in 0..(len-1)
        space_e = nil
        latin_e = nil
        space_break = false
        latin_break = false

        for j in i..(len-1)
          if space_break and latin_break
            break
          end
          ch = string[j]
          if not space_break
            if ch == " "
              space_e = j + 1
            else
              space_break = true
            end
          end

          if latin_break and j >= next_latin
            if /A-Za-z/.match(ch)
              latin_e = j + 1
            else
              latin_break = true
            end
          end
        end

        if not space_e.nil?
          dag << [i, space_e, :SPACE]
        end
        if not latin_e.nil?
          dag << [i, latin_e, :LATIN]
          next_latin = latin_e;
        end
      end
    end

    def _build_by_dict(dag, string, len)
      for i in 0..(len-1)
        iter = DictIter.new @dict
        for j in i..(len-1)
          ch = string[j]
          status = iter.walk ch
          if status == :INVALID
            break
          elsif status == :ACTIVE_BOUNDARY
            dag << [i, j + 1, :DICT]
          end
        end
      end
    end
  end
end
