"""
    closure(f)
A macro that execute the input function on its output until it stays the same.
"""
macro closure(f)
    return :(function _closure(s, args...)
                while true
                    n = f(deepcopy(s), args)
                    if n == s
                        return s
                    end
                    s = n
                end
            end)
end