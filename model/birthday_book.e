note
	description: "Summary description for {BIRTHDAY_BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY_BOOK

create
	make_empty

feature -- Attributes
	names: ARRAY[STRING]
	birthdays: LIST[BIRTHDAY]
	count: INTEGER

feature -- query
	get_birthday(name: STRING): BIRTHDAY
		require
			existing_name:
				names.has (name)
		local
			i: INTEGER
		do
			create Result.make(10, 15)
			from
				i := 1
			until
				i > names.count

			loop
				if names[i] ~ name then
					Result := birthdays[i]
				end
				i := i + 1
			end
			--Result
		ensure
			correct_result:
				Result ~ birthdays[index_of_name(name)]
		end
	get_detachable_birthday (name: STRING): detachable BIRTHDAY
			local
				i: INTEGER
			do
--				create Result.make(10, 15)
--				from
--					i := 1
--				until
--					i > names.count

--				loop
--					if names[i] ~ name then
--						Result := birthdays[i]
--					end
--					i := i + 1
--				end
				i := index_of_name(name)
				if i > 0 then
					Result := birthdays[i]
				end

		ensure
			case_of_non_void_result:
				attached Result implies Result ~ birthdays[index_of_name(name)]
			case_of_void_result:
			--	Result = void implies not names.has (name)
				not attached Result implies not names.has (name)
		end


		celebrate(today : BIRTHDAY): like names
			do
				create Result.make_empty
				Result.compare_objects
				across
					birthdays as l_b
				loop
					if
						l_b.item ~ today
					then
						Result.force(names[l_b.cursor_index], Result.count + 1)
					end
				end

			ensure
				lower_of_result:
					Result.lower = 1
				every_name_in_result_is_an_existing_name:
					across Result is l_n all names.has (l_n) end
				every_name_in_result_has_birthday_today:
					across Result is l_n all get_birthday(l_n) ~ today end
			end
feature -- Auxilary Queries
	index_of_name (name: STRING) : INTEGER
		local
			i: INTEGER
		do
			i := 1
			Result := 0
			across
				names is l_n
			loop
				if l_n ~ name then
					Result := i
				end
				 i := i + 1

			end
		end
feature -- Command
	make_empty
		do
			create names.make_empty
			names.compare_objects
			create {LINKED_LIST[BIRTHDAY]} birthdays.make
			birthdays.compare_objects
		end

	add (name: STRING; birthday: BIRTHDAY)
		require
			non_existing_name:
			--	not names.has (name)
		--	not (across names is l_n some l_n ~	name end)
		 (across names is l_n all l_n /~	name end)
		do
			names.force (name, names.count + 1)
			birthdays.extend (birthday)
			count := count + 1
		ensure
			count_incremented:
				count = old count + 1
			name_added_to_end:
				names[count] ~ name
			birthday_added_to_end:
				birthdays[count] ~ birthday
		end
invariant
	consistent_counts:
		current.count = names.count and count = birthdays.count

	no_duplicate_names:
		across 1 |..| names.count is l_i all
		across 1 |..| names.count is l_j all
			l_i /= l_j implies names[l_i] /~ names [l_j]
		end
		end
end
