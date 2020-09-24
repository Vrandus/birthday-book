note
	description: "Summary description for {TEST_BIRTHDAY_BOOK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_BIRTHDAY_BOOK
inherit
	ES_TEST
create
	make

feature -- Add tests
	make
	do
		add_violation_case_with_tag("non_existing_name", agent t_precond_add)
		add_violation_case_with_tag ("name_added_to_end", agent t_postcond_add)
		add_boolean_case(agent t_add)
		add_boolean_case(agent t_get)
		add_boolean_case(agent t_celebrate)
	end


feature -- Boolean tests

	t_celebrate: BOOLEAN
	local
			bb: BIRTHDAY_BOOK
			bd1, bd2, bd3: BIRTHDAY
		do
			comment("t_celebrate: test getting birthdays from birthday book")
			create bb.make_empty
			Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end
			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("alan", bd1)
			bb.add ("mark", bd2)
			bb.add ("tom", bd3)
			Result := bb.celebrate ((create {BIRTHDAY}.make (9, 14))).has ("alan")
		end
	t_add : BOOLEAN
		local
			bb: BIRTHDAY_BOOK
			bd1, bd2, bd3: BIRTHDAY
		do
			comment("t_get: test getting birthdays from birthday book")
			create bb.make_empty
			Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end
			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("alan", bd1)
			bb.add ("mark", bd2)
			bb.add ("tom", bd3)
			Result :=
				bb.get_birthday ("mark").month = 3 and bb.get_birthday ("mark").day = 31
				and
				bb.get_birthday("mark") ~ (create {BIRTHDAY}.make (3, 31))
			check Result end

			Result := bb.get_detachable_birthday ("mark") ~ (create {BIRTHDAY}.make (3, 31))
			check Result end

			check attached bb.get_detachable_birthday ("mark") as mark_bd then
				Result := mark_bd.month = 3 and mark_bd.day = 31
			end
			check Result end

			check
				attached bb.get_detachable_birthday ("alan") as alan_bd
				and
				attached bb.get_detachable_birthday ("tom") as tom_bd
			then
				Result :=
					alan_bd.month = 9 and alan_bd.day = 14
					and
					tom_bd.month = 7 and tom_bd.day = 2
			end
		end

	t_get : BOOLEAN
		local
			bb: BIRTHDAY_BOOK
			bd1, bd2, bd3: BIRTHDAY
		do
			comment("t_add: test additions to the birthday book")
			create bb.make_empty
			Result := bb.count = 0 and bb.names.count = 0 and bb.birthdays.count = 0
			check Result end
			create bd1.make (9, 14)
			create bd2.make (3, 31)
			create bd3.make (7, 2)
			bb.add ("alan", bd1)
			bb.add ("mark", bd2)
			bb.add ("tom", bd3)
			Result := bb.count = 3 and bb.names[1] ~ "alan" and bb.birthdays[1] ~ (create {BIRTHDAY}.make (9, 14))

		end


feature -- Violation tests
	t_precond_add
		local
			bb:BIRTHDAY_BOOK
		--	bd:BIRTHDAY
		do
			comment("t_precond_add: test the precondition of add with an existing name")
			create bb.make_empty
		--	create bd.make (9, 14)
			bb.add ("alan", create {BIRTHDAY}.make (9, 14))
			bb.add ("alan", create {BIRTHDAY}.make (4, 23))

		end
	t_postcond_add
		local
			bd: BIRTHDAY_BOOK_VIOLATING_NAME_ADDED_TO_END
		do
			comment("t_postcond_add: test the postcondition of add with wrong implementation")
			create bd.make_empty
			bd.add("alan", create {BIRTHDAY}.make (7, 2))
			bd.add("mark", create {BIRTHDAY}.make (8, 15))
		end
end
