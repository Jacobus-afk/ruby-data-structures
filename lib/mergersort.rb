# frozen_string_literal: true

def merge(left_half, right_half)
  merge_arr = []
  until left_half.empty? || right_half.empty?
    merge_arr << (left_half[0] > right_half[0] ? right_half.shift : left_half.shift)
  end
  merge_arr + left_half + right_half
end

def mergesort(arr)
  len = arr.length
  return arr if len < 2

  half_len = len / 2
  left_half = mergesort(arr[0..half_len - 1])
  right_half = mergesort(arr[half_len..-1])

  merge(left_half, right_half)
end

# random_array = Array.new(21) { rand(1..200) }
# # random_array = [5, 6, 1, 3, 7, 8, 2, 4]
# puts "Unsorted: #{random_array}"
# sorted_arr = mergesort(random_array)
# puts "Sorted: #{sorted_arr}"
