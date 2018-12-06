defmodule AdventTest do
  use ExUnit.Case, async: true

  doctest Advent.DayOne
  doctest Advent.DayTwo
  doctest Advent.DayThree
  doctest Advent.DayFour
  doctest Advent.DayFive
  doctest Advent.DaySix

  @tag :skip
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

  @tag :skip
  test "Day 5" do
    file = Advent.DayFive.get_file()
    assert Advent.DayFive.part_one(file) == 10564
    assert Advent.DayFive.part_two(file) == 6336
  end

  @tag :skip
  test "Day 6" do
    file = Advent.DaySix.get_file()
    assert Advent.DaySix.part_one(file) == 3276
    assert Advent.DaySix.part_two(file) == 38380
  end
end
