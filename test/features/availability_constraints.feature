Feature: Once rooms_availability_constraints is installed
  I should be able to create bookable units availability range constrains

@api @javascript
Scenario: I can create bookable units range constraints.
  Given I am logged in as a user with the "administrator" role

  # Creating a unit type and some units.
  Given unit types:
  | type     | label    | base_price | min_sleeps | max_sleeps | min_children | max_children |
  | standard | Standard | 100        | 2          | 3          | 0            | 1            |

  # Creating a bunch of units programmatically.
  Given "standard" units:
  | name       | base_price |
  | Normal     | 120        |
  | Special    | 130        |

  Then I am on "admin/rooms/units/unit-types/manage/standard"
  And I check the box "rooms_availability_range_unit"
  And I check the box "rooms_availability_range_type"
  And I press the "Save unit type" button

  Then I am editing the "Normal" unit
  And I add a constraint from "2016-01-03" to "2016-03-03" "must" start on "1" and the minimum is "" and the maximum is "5"
  And I add a constraint from "2016-03-04" to "2016-06-03" "if" start on "2" and the minimum is "3" and the maximum is ""
  And I add a constraint from "2016-03-04" to "2016-06-03" "" start on "" and the minimum is "" and the maximum is "5"
  And I add an always constraint where "" start on "" and the minimum is "2" and the maximum is ""
  And I press the "Save Unit" button

  Then I will be able to make a booking for "Normal" unit from "2016-01-05" to "2016-01-08"
  And I won't be able to make a booking for "Normal" unit from "2016-01-04" to "2016-01-15"
  And I won't be able to make a booking for "Normal" unit from "2016-01-06" to "2016-01-09"
  And I won't be able to make a booking for "Normal" unit from "2016-03-08" to "2016-03-10"
  And I won't be able to make a booking for "Normal" unit from "2016-03-08" to "2016-03-16"
  And I will be able to make a booking for "Normal" unit from "2016-03-08" to "2016-03-12"
  And I will be able to make a booking for "Normal" unit from "2016-03-11" to "2016-03-14"
  And I won't be able to make a booking for "Normal" unit from "2016-10-10" to "2016-10-11"
  And I will be able to make a booking for "Normal" unit from "2016-10-10" to "2016-10-21"
  
  Then I am on "admin/rooms/units/unit-types/manage/standard"

  And I add a constraint from "2016-06-04" to "2016-09-03" "must" start on "3" and the minimum is "" and the maximum is "5"
  And I add a constraint from "2016-09-04" to "2016-12-03" "if" start on "2" and the minimum is "3" and the maximum is ""
  And I add a constraint from "2016-09-04" to "2016-12-03" "" start on "" and the minimum is "" and the maximum is "5"
  And I press the "Save unit type" button

  Then I will be able to make a booking for "Special" unit from "2016-08-05" to "2016-08-08"
  And I won't be able to make a booking for "Special" unit from "2016-08-03" to "2016-08-14"
  And I won't be able to make a booking for "Special" unit from "2016-08-06" to "2016-08-09"
  And I will be able to make a booking for "Special" unit from "2016-10-20" to "2016-10-24"
  And I won't be able to make a booking for "Special" unit from "2016-10-20" to "2016-10-28"
  And I will be able to make a booking for "Special" unit from "2016-10-21" to "2016-10-22"
  And I will be able to make a booking for "Special" unit from "2016-10-10" to "2016-10-11"

  Then I won't be able to make a booking for "Normal" unit from "2016-10-10" to "2016-10-21"
