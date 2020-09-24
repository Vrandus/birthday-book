note
	description: "Summary description for {BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END
inherit
	BIRTHDAY_BOOK
		redefine
			add
		end
create
	make_empty


feature -- commad
	add (name: STRING; birthday: BIRTHDAY)

		do
			names.force (name, names.count + 1)
			birthdays.extend (birthday)
			count := count + 1
			if count > 1 then
				names[count] := names[count - 1]
			end
		end
end
