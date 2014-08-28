module ThaiLang
  class RangesBuilder
    S = 0
    E = 1
    LINK_TYPE = 2

    POINTER = 0
    WEIGHT = 1
    PATH_UNK = 2
    PATH_LINK_TYPE = 3

    def _build_index(dag, pos)
      index = {}
      dag.each do |range|
        if not index.has_key?(range[pos])
          index[range[pos]] = []
        end
        index[range[pos]] << range
      end
      index
    end

    def _build_e_index(dag)
      _build_index(dag, E)
    end

    def _build_s_index(dag)
      _build_index(dag, S)
    end

    def _compare_path_info(a, b)
      a[PATH_UNK] < b[PATH_UNK] and a[WEIGHT] < b[WEIGHT]
    end

    def _build_path(len, s_index, e_index)
      path = Array.new(len + 1) {|i| nil}
      path[0] = [0, 0, 0, :UNK]
      left_boundary = 0
      for i in 1..len
        if e_index.has_key?(i)
          e_index[i].each do |range|
            s = range[S]
            if not path[s].nil?
              info = [s, path[s][WEIGHT] + 1, path[s][PATH_UNK], range[LINK_TYPE]]
              if path[i].nil? or _compare_path_info(info, path[i])
                path[i] = info
              end
            end
          end
          if not path[i].nil?
            left_boundary = i
          end
        end
        if path[i].nil? and s_index.has_key?(i)
          info = [left_boundary,
          path[left_boundary][WEIGHT] + 1,
          path[left_boundary][PATH_UNK] + 1, :UNK]
          path[i] = info;
        end
      end
      if path[len].nil?
        path[len] = [left_boundary,
        path[left_boundary][WEIGHT] + 1,
        path[left_boundary][PATH_UNK] + 1, :UNK]
      end
      path
    end

    def _path_to_ranges(path, len)
      ranges = []
      i = len
      while i > 0
        info = path[i]
        s = info[POINTER]
        ranges << [s, i, info[PATH_LINK_TYPE]]
        i = s
      end
      ranges.reverse
    end

    def build_from_dag(dag, len)
      s_index = _build_s_index(dag)
      e_index = _build_e_index(dag)
      path = _build_path(len, s_index, e_index)
      _path_to_ranges(path, len)
    end
  end
end
