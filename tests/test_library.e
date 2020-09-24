note
	description: "Summary description for {TEST_LIBRARY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_LIBRARY
inherit
	ES_TEST

create
	make

feature -- Constructor
	make
		do
			add_boolean_case(agent test_arrays)
			add_boolean_case(agent test_lists)
			add_boolean_case(agent test_across_loops)
			add_boolean_case (agent test_quantifications)
		end
feature -- boolean queries
	test_lists: BOOLEAN
		local
			s1, s2, s3: LINKED_LIST[STRING]
			i: INTEGER
		do
			comment("test_lists: test basic operations of lists")
			create s1.make
			Result :=
				s1.count = 0 and s1.is_empty
				and
				not s1.valid_index (0) and not s1.valid_index (1)
			check Result end
			s1.extend ("alan")
			s1.extend ("mark")
			s1.extend ("tom")
			Result :=
				s1.count = 3 and not s1.is_empty
				and
				not s1.valid_index (0) and s1.valid_index (1) and s1.valid_index (2) and s1.valid_index (3)
				and
				s1[1] ~"alan" and s1[2] ~ "mark" and s1[3] ~ "tom"
			check Result end
			Result :=
				s1.object_comparison = false
				and
				s1.has ("alan") = false
				and
				s1.occurrences ("alan") = 0
			check Result end

			s1.compare_objects
			Result :=
				s1.object_comparison = true
				and
				s1.has ("alan") = true
				and
				s1.occurrences ("alan") = 1
			check Result end
			create s2.make
			from
				i := 1
			until
				i > s1.count
			loop
				s2.extend (s1[i])
				i := i + 1
			end

			Result :=
					s2.count = 3 and not s2.is_empty
					and
					not s2.valid_index (0) and s2.valid_index (1) and s2.valid_index (2) and s2.valid_index (3)
					and
					s2[1] ~"alan" and s2[2] ~ "mark" and s2[3] ~ "tom"
				check Result end
			Result := s1 /= s2
			check Result end

			Result := s1 /~ s2
			check Result end

			s2.compare_objects
			Result := s1 ~ s2
			check Result end
			create s3.make
			from
				s1.start
			until
				s1.after
			loop
				s3.extend (s1.item)
				s1.forth
			end
			Result :=
					s3.count = 3 and not s3.is_empty
					and
					not s3.valid_index (0) and s3.valid_index (1) and s3.valid_index (2) and s3.valid_index (3)
					and
					s3[1] ~"alan" and s3[2] ~ "mark" and s3[3] ~ "tom"
				check Result end

			Result :=
				s1 /= s3 and s2 /= s3
				and
				s1 /~ s3 and s2 /~ s3
			check Result end
			s3.compare_objects
			Result :=
				s1 /= s3 and s2 /= s3
				and
				s1 ~ s3 and s2 ~ s3
			check Result end
			s2[2] := "jim"
			Result :=
				s2.count = 3 and s2[1] ~ "alan" and s2[2] ~ "jim" and s2[3] ~ "tom"
		end
	test_arrays: BOOLEAN
		local
			s1, s2: ARRAY[STRING]
			i: INTEGER
		do
			comment("test_arrays: test basic operations of arrays")
			create s1.make_empty
			Result :=
				s1.lower = 1 and s1.upper =0 and s1.count = 0 and s1.is_empty
				and
				not s1.valid_index (0) and not s1.valid_index (1)
			check Result end
			s1.force ("alan", s1.count + 1)
			s1.force ("mark", s1.count + 1)
			s1.force ("tom", s1.count + 1)
			Result :=
				s1.lower = 1 and s1.upper = 3 and s1.count = 3 and not s1.is_empty
				and
				not s1.valid_index (0) and s1.valid_index (1) and s1.valid_index (2) and s1.valid_index (3)
				and
				s1[1] ~"alan" and s1[2] ~ "mark" and s1[3] ~ "tom"
			check Result end
			Result :=
				s1.object_comparison = false
				and
				s1.has ("alan") = false
				and
				s1.occurrences ("alan") = 0
			check Result end

			s1.compare_objects
			Result :=
				s1.object_comparison = true
				and
				s1.has ("alan") = true
				and
				s1.occurrences ("alan") = 1
			check Result end
			create s2.make_empty
			from
				i := 1
			until
				i > s1.count
			loop
				s2.force (s1[i],s2.count + 1)
				i := i + 1
			end

			Result :=
					s2.lower = 1 and s2.upper = 3 and s2.count = 3 and not s2.is_empty
					and
					not s2.valid_index (0) and s2.valid_index (1) and s2.valid_index (2) and s2.valid_index (3)
					and
					s2[1] ~"alan" and s2[2] ~ "mark" and s2[3] ~ "tom"
				check Result end
			Result := s1 /= s2
			check Result end

			Result := s1 /~ s2
			check Result end

			s2.compare_objects
			Result := s1 ~ s2

			s2[2] := "jim"
			s2.put ("jeremy", 3)
			Result :=
				s2.count = 3 and s2[1] ~ "alan" and s2[2] ~ "jim" and s2[3] ~ "jeremy"
		end

		test_across_loops: BOOLEAN
			local
				a: ARRAY[STRING]
				list1, list2, list3: LINKED_LIST[STRING]
			do
				comment("test_across_loops: use across as loop instructions")
				a := <<"alan", "mark", "tom">>
				create list1.make
				across
					1 |..| a.count as l_i
				loop
					list1.extend (a[l_i.item])
				end
				Result := list1.count = 3 and list1[1] ~ "alan" and list1[2] ~ "mark" and list1[3] ~ "tom"
				check Result end


				create list2.make
				across
					1 |..| a.count is l_i
				loop
					list2.extend (a[l_i])
				end

				Result := list2.count = 3 and list2[1] ~ "alan" and list2[2] ~ "mark" and list2[3] ~ "tom"
				check Result end
				create list3.make
				across
					a is l_name
				loop
					list3.extend(l_name)
				end

				Result := list3.count = 3 and list3[1] ~ "alan" and list3[2] ~ "mark" and list3[3] ~ "tom"
				check Result end
			end
		test_quantifications: BOOLEAN
			local
				a: ARRAY[STRING]
			do
				comment("test_quantifications: use of across as boolean expressions")
				Result :=
					not (across
						1|..| 10 is l_i
					all
						l_i > 5
					end)
					and
					across
						1|..| 10 is l_i
					some
						l_i > 5
					end
				check Result end
				a:= <<"yuna", "suyeon", "heeyeon">>
				Result :=
					not (across
						1 |..| a.count is l_i
					all
						a[l_i].count > 4
					end)
					and
					(across
						1 |..| a.count is l_i
					some
						a[l_i].count > 4
					end)
				check Result end
				Result :=
					not (across
						a is l_s
					all
						l_s.count > 4
					end)
					and
					(across
						a is l_s
					some
						l_s.count > 4
					end)
				check Result end
				Result :=
					across 1|..| (a.count - 1) is l_index all a[l_index].count <= a[l_index + 1].count  end
			end


end
