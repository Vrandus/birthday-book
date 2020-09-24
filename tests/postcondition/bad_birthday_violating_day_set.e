note
	description: "Summary description for {BAD_BIRTHDAY_VIOLATING_DAY_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BAD_BIRTHDAY_VIOLATING_DAY_SET
inherit
	BIRTHDAY
		redefine
			make
		end
create
	make

feature -- redefined command
	make (m: INTEGER; d: INTEGER)
		do
			month := m
			day := m
		end
end
