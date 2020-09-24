note
	description: "Summary description for {BIRTHDAY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY
inherit
	ANY
		redefine
			is_equal
		end

	create
		make
	feature -- Commands

	make(m: INTEGER; d: INTEGER)
	require
		valid_month: 1 <= m and m <= 12
		valid_day: 1 <= d and d <= 31
		valid_combination:
			(is_month_with_31_days (m) implies 1 <= d and d <= 31)
			and
			(is_month_with_30_days (m) implies 1 <= d and d <= 30)
			and
			(m = 2 implies 1 <= d and d <= 29)
	do
		month := m
		day := d
	ensure
		month_set: month = m
		day_set: day = d
	end

	feature -- Attributes
	month: INTEGER
	day: INTEGER
	feature -- Queries
		is_month_with_31_days (m: INTEGER): BOOLEAN
			require
				valid_month: 1 <= m and M <= 12
			local
				months: ARRAY[INTEGER]
			do
				months := <<1, 3, 5, 7, 8, 10, 12>>
				Result := months.has (m)

			ensure
				class
				correct_result:
					(m = 1 or m = 3 or m = 5 or m = 7 or m = 8 or m = 10 or m = 12) = Result
			end

		is_month_with_30_days (m: INTEGER): BOOLEAN
			require
				valid_month: 1 <= m and M <= 12
			local
				months: ARRAY[INTEGER]
			do
				months := <<4, 6, 9, 11>>
				Result := months.has (m)

			ensure
				class
				correct_result:
					(m = 4 or m = 6 or m = 9 or m = 11) = Result
			end
	feature -- Equality

	is_equal (other: like Current): BOOLEAN
		do
			Result := Current.month = other.month and Current.day = other.day
		end

	feature -- String Representation

	invariant -- class invariant
		valid_month: 1 <= month and month <= 12
		valid_day: 1 <= day and day <= 31
		valid_combination:
			(is_month_with_31_days (month) implies 1 <= day and day <= 31)
			and
			(is_month_with_30_days (month) implies 1 <= day and day <= 30)
			and
			(month = 2 implies 1 <= day and day <= 29)

end
