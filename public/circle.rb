def main
  line
  circle
  int @line, @circle
  results
end

def line
  @line = {}

  print 'enter line point 1: '
  p1 = gets.chomp.split(',').map &:to_f
  @line[:x1] = p1.first
  @line[:y1] = p1.last

  print 'enter line point 2: '
  p2 = gets.chomp.split(',').map &:to_f
  @line[:x2] = p2.first
  @line[:y2] = p2.last

  x1 = @line[:x1]
  x2 = @line[:x2]
  y1 = @line[:y1]
  y2 = @line[:y2]

  m = @line[:slope] = (y2 - y1) / (x2 - x1)

  b = y1 - m * x1
  @line[:yint] = b
end

def circle
  @circle = {}

  print 'enter center of circle: '
  p1 = gets.chomp.split(',').map &:to_f
  @circle[:x] = p1.first
  @circle[:y] = p1.last

  print 'enter radius of circle: '
  p2 = gets.chomp
  @circle[:r] = p2.to_f
end

def int(l, c)
  # x1=l1[:x1];y1=l1[:y1];x2=l1[:x2];y2=l1[:y2]
  # x3=l2[:x1];y3=l2[:y1];x4=l2[:x2];y4=l2[:y2]
  #
  # part1 = (x2 * y1 - x1 * y2) * (x4 - x3) - (x4 * y3 - x3 * y4) * (x2 - x1)
  # part2 = (x2 - x1) * (y4 - y3) - (x4 - x3) * (y2 - y1)
  # @x = (part1 / part2).round 2
  #
  # part3 = (x2 * y1 - x1 * y2) * (y4 - y3) - (x4 * y3 - x3 * y4) * (y2 - y1)
  # @y = (part3 / part2).round 2
end

def results
  puts "intersection: #{@x},#{@y}"
end

main
