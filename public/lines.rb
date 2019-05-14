def main
  line1
  line2
  int @line1, @line2
  results
end

def line1
  @line1 = {}

  print 'enter line 1 point 1: '
  p1 = gets.chomp.split(',').map &:to_f
  @line1[:x1] = p1.first
  @line1[:y1] = p1.last

  print 'enter line 1 point 2: '
  p2 = gets.chomp.split(',').map &:to_f
  @line1[:x2] = p2.first
  @line1[:y2] = p2.last
end

def line2
  @line2 = {}

  print 'enter line 2 point 1: '
  p1 = gets.chomp.split(',').map &:to_f
  @line2[:x1] = p1.first
  @line2[:y1] = p1.last

  print 'enter line 2 point 2: '
  p2 = gets.chomp.split(',').map &:to_f
  @line2[:x2] = p2.first
  @line2[:y2] = p2.last
end

def int(l1, l2)
  x1=l1[:x1];y1=l1[:y1];x2=l1[:x2];y2=l1[:y2]
  x3=l2[:x1];y3=l2[:y1];x4=l2[:x2];y4=l2[:y2]

  part1 = (x2 * y1 - x1 * y2) * (x4 - x3) - (x4 * y3 - x3 * y4) * (x2 - x1)
  part2 = (x2 - x1) * (y4 - y3) - (x4 - x3) * (y2 - y1)
  @x = (part1 / part2).round 2

  part3 = (x2 * y1 - x1 * y2) * (y4 - y3) - (x4 * y3 - x3 * y4) * (y2 - y1)
  @y = (part3 / part2).round 2
end

def results(num = nil)
  if num
    puts "intersection #{num}: #{@x},#{@y}"
  else
    puts "intersection: #{@x},#{@y}"
  end
end

def main2
  get_points
  make_lines
  get_ints
end

def get_points
  @points = {}
  (1..5).each do |x|
    print "enter point #{x}: "
    input = gets.chomp.split(',').map &:to_f
    @points[x] = input
  end
end

def make_lines
  @lines = {}
  (1..5).each do |x|
    line = @lines[x] = {}
    line[:x1] = @points[x].first
    line[:y1] = @points[x].last
    y = (x + 2) % 5
    y = 5 if y == 0
    line[:x2] = @points[y].first
    line[:y2] = @points[y].last
  end
end

def get_ints
  (1..5).each do |x|
    y = x - 1
    y = 5 if y == 0
    int @lines[x], @lines[y]
    results
  end
end

main2
