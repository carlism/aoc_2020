defmodule BasicMath do
  def gcd(a, 0), do: a
  def gcd(0, b), do: b
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(0, 0), do: 0
  def lcm(a, b), do: floor(a * b / gcd(a, b))
  def lcm([x]), do: x
  def lcm([first | rest]), do: lcm(first, lcm(rest))
end
