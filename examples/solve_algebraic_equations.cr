require "../src/cgl"

alias Equation = Proc(Array(Float64), Float64)

# A set of algebraic equations
a = ->(args : Array(Float64)) { args[0] ** 2 + 3 }
b = ->(args : Array(Float64)) { Math.sin(args[0] * args[1]) }
c = ->(args : Array(Float64)) { Math.sqrt(args[0] - 0.5) }
d = ->(_args : Array(Float64)) { Math::PI / 2 }
e = ->(_args : Array(Float64)) { 0.134 + 1 }

result = Hash(Equation, Float64).new(0.0)
digraph = CGL::DiGraph(Equation).new(edges: { {a, b}, {b, c}, {b, e}, {c, d} })

# Uses a depth first search from equation A to find an appropriate
# order to solve the set of equations.
schedule = digraph.depth_first_search(a).to_a.reverse!

# Solve the system of equations
schedule.each do |equation|
  args = [] of Float64
  digraph.each_adjacent(equation) { |dep| args << result[dep] }
  result[equation] = equation.call(args)
end

# Print the solution
puts "solution:"
{a, b, c, d, e}.each_with_index do |eq, i|
  puts "#{'a' + i} = #{result[eq]}"
end
