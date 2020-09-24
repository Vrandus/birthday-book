note
	description: "[
		Test examples with arrays and regular expressions.
		First test fails as Result is False by default.
		Write your own tests.
		Included libraries:
			base and extension
			Espec unit testing
			Mathmodels
			Gobo structures
			Gobo regular expressions
		]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision 19.05$"

class
	TEST_BIRTHDAY

inherit

	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do

			add_boolean_case (agent t_always_passes)
			add_boolean_case (agent t_static_query)
			add_boolean_case (agent t_create_new_birthday)
--			add_boolean_case (agent t_create_invalid_birthday)
			add_violation_case_with_tag ("valid_combination", agent t_precond_brithday_make)
			add_violation_case_with_tag ("day_set", agent t_postcond_birthday_make)
			add_boolean_case (agent t_birthday_equality)
		end

feature -- tests
	-- TODO: write a boolean test query on is_month_with_31_days

	t_birthday_equality: BOOLEAN
		local
			bd1, bd2 : BIRTHDAY
		do
			comment("t_birthday_equality: test red and obj equality of birthdays")
			create bd1.make (10, 15)
			create bd2.make (10, 15)

			Result := bd1 /= bd2
			check Result end
			Result := bd1.is_equal (bd2)
			check Result end
			Result := bd1 ~ bd2
			
		end

	t_static_query: BOOLEAN
		do
			comment("t_static_query: test is_month_with_31_days")
			Result := {BIRTHDAY}.is_month_with_31_days(1)
			check Result end
			Result := not {BIRTHDAY}.is_month_with_31_days(4)

		end
	t_always_passes: BOOLEAN
		do
			comment("t_always: a test always passing")
			Result := true

		end
	t_create_new_birthday: BOOLEAN
		local
			bd: BIRTHDAY
		do
			create bd.make (10,15)
			comment("t_create_new_birthday: birthday constructor")
			Result := bd.month = 10 and bd.day = 15
			check Result end
			create bd.make (9,14)
			Result := bd.month = 9 and bd.day = 14
			check Result end
			create bd.make (7,15)
			Result := bd.month = 7 and bd.day = 15
		end

	t_precond_brithday_make
		local
			bd: BIRTHDAY
		do
			comment ("t_precond_brithday_make: valid_combination create invalid birthday")
			create bd.make (11, 31)
		end

		t_postcond_birthday_make
			local
				bd:BAD_BIRTHDAY_VIOLATING_DAY_SET
			do
				comment("t_postcond_birthday_make: test that the postcondition with tag day_set is violated as expected")
				create bd.make(10,14)
			end




end
