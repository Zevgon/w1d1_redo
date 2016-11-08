class Array
	def my_each(&prc)
		idx = 0
		while idx < length
			prc.call(self[idx])
			idx += 1
		end
		self
	end

	def my_select(&prc)
		selections = []
		my_each do |el|
			selections << el if prc.call(el)
		end

		selections
	end

	def my_reject(&prc)
		selections = []
		my_each do |el|
			selections << el unless prc.call(el)
		end

		selections
	end

	def my_any(&prc)
		my_each do |el|
			return true if prc.call(el)
		end

		false
	end

	def my_flatten
		new_arr = []
		my_each do |el|
			if el.is_a?(Array)
				new_arr.concat(el.flatten)
			else
				new_arr << el
			end
		end

		new_arr
	end

	def my_zip(*other_arrays)
		result = []
		idx = 0
		while idx < length
			next_arr = [self[idx]]
			other_arrays.each do |other_array|
				next_arr << other_array[idx]
			end
			result << next_arr
			idx += 1
		end

		result
	end

	def my_rotate(shift = 1)
		shift %= length
		drop(shift).concat(take(shift))
	end

	def my_join(separator = '')
		result = ''
		each.with_index do |el, idx|
			result << el
			result << separator unless idx == length - 1
		end

		result
	end

	def my_reverse
		result = []
		idx = length - 1
		while idx >= 0
			result << self[idx]
			idx -= 1
		end

		result
	end
end
