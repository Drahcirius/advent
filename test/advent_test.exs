defmodule AdventTest do
  use ExUnit.Case, async: true

  doctest Advent.DayOne
  doctest Advent.DayTwo
  doctest Advent.DayThree
  doctest Advent.DayFour

  @tag :skip
  @tag :"1"
  test "Day 1" do
    file = Advent.DayOne.get_file()
    assert Advent.DayOne.part_one(file) == 477
    assert Advent.DayOne.part_two(file) == 390
  end

  @tag :skip
  test "Day 2" do
    file = Advent.DayTwo.get_file()
    assert Advent.DayTwo.part_one(file) == 8118
    assert Advent.DayTwo.part_two(file) == "jbbenqtlaxhivmwyscjukztdp"
  end

  @tag :skip
  test "Day 3" do
    file = Advent.DayThree.get_file()
    assert Advent.DayThree.part_one(file) == 103_482
    assert Advent.DayThree.part_two(file) == 686
  end

  @tag :skip
  test "Day 4" do
    file = Advent.DayFour.get_file()
    assert Advent.DayFour.part_one(file) == 106_710
    assert Advent.DayFour.part_two(file) == 10491
  end
end
