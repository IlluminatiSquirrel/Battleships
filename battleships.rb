=begin
Written by: Gabriele Kukauskaite
=end

require "colorize"

grid = Array.new(10) {Array.new(10, '-')}     #array for placing ships
grid2 = Array.new(10) {Array.new(10,'-')}     #array for displaying the grid and user interface
grid3 = Array.new(10) {Array.new(10, false)}  #array for keeping track of what grid position has already been revealed

orientation_array = ['horizontal', 'vertical']
ship_array = [2, 3, 3, 4, 5]

#assigning 5 ships at random positions
(0...5).each do |a|
  count = 0
  x = rand(grid.length)
  y = rand(grid.length)
  if grid[x][y] != '-'
    redo                               #redo the loop if randomized position is not free
  end
  orientation = orientation_array[rand(orientation_array.length)]
  if orientation == 'horizontal'
    if y + (ship_array[a] - 1) <= 9    #checks if the ship won't go out of the grid
      (1...ship_array[a]).each do |b|
        if grid[x][y + b] == '-'       #checks if all squares that are needed to place the ship are free
          count += 1                   #counts how many free squares there are
        end
      end
      if count == ship_array[a] - 1    #checks if the amount of free squares matches the amount of free squares needed
        (1...ship_array[a]).each do |c|
            grid[x][y] = a
            grid[x][y + c] = a
        end
      else
        redo                           #redo the loop if there is not enough free squares to place the ship
      end
    else
      redo                             #redo the loop if ship goes out of the grid
    end
  else
    if x + (ship_array[a] - 1) <= 9
      (1...ship_array[a]).each do |b|
        if grid[x + b][y] == '-'
        count += 1
        end
      end
      if count == ship_array[a] - 1
        (1...ship_array[a]).each do |c|
          grid[x][y] = a
          grid[x + c][y] = a
        end
      else
        redo
      end
    else
      redo
    end
  end
end

#the user interface
count = 0
ship0 = 0  #sub-marine
ship1 = 0  #destroyer
ship2 = 0  #destroyer
ship3 = 0  #cruiser
ship4 = 0  #aircarft carrier
moves = 0
#loop for entering coordinates and redrawing the grid
loop do
  puts
  print 'Enter row number: '
  x2 = gets.chomp.to_i
  print 'Enter column number: '
  y2 = gets.chomp.to_i
  if x2 <= -1 || x2 >= 10 || y2 <= -1 || y2 >= 10  #if entered position is not valid the loop is repeated
    print "#{x2}, #{y2} is not a valid position"
    redo
  end
  if !grid3[x2][y2]                                #if the entered position hasn't been hit (value=false) do the rest
    if grid[x2][y2] != '-'                         #ckecks if there's a ship at that position
      grid2[x2][y2] = grid2[x2][y2].red.on_red
      count += 1                                   #keeps track of the squares that have been hit
      puts "You have hit a ship at #{x2}, #{y2}"
      if grid[x2][y2] == 0                         #keeps track of what kind of ships have been hit and if they are destroyed
        ship0 += 1
        if ship0 == 2
          puts 'Sub-marine has been destroyed'
        end
      elsif grid[x2][y2] == 1
        ship1 += 1
        if ship1 == 3
          puts 'Destroyer has been destroyed'
        end
      elsif grid[x2][y2] == 2
        ship2 += 1
        if ship2 == 3
          puts 'Destroyer has been destroyed'
        end
      elsif grid[x2][y2] == 3
        ship3+= 1
        if ship3 == 4
          puts 'Cruiser has been destroyed'
        end
      else
        ship4 += 1
        if ship4 == 5
          puts 'Aircraft carrier has been destroyed'
        end
      end
      grid[x2][y2] = '-'  #this is needed so that there wouldn't be near-misses when the square has been already hit
    elsif grid[x2][y2] == '-'
      if (x2!=9 && grid[x2+1][y2] != '-') || (x2!=0 && grid[x2-1][y2] != '-') || (y2!=0 && grid[x2][y2-1] != '-') || (y2!=9 && grid[x2][y2+1] != '-')
        puts "That was a near-miss! There's only water at #{x2}, #{y2}"
        grid2[x2][y2] = grid2[x2][y2].blue.on_blue
      else
        grid2[x2][y2] = grid2[x2][y2].blue.on_blue
        puts "You missed! There's only water at #{x2}, #{y2}"
      end
    end
    moves += 1
    grid3[x2][y2] = true
    #redraws/updates the grid after evey valid move
    print ' '.red.on_black
    (0..9).each do |num|
      print " #{num}".red.on_black
    end
    num = 0
    grid2.each do |element1|
      puts
      print "#{num} ".red.on_black
      element1.each do |element2|
        print "#{element2} "
      end
      num += 1
    end
  else
    print "#{x2}, #{y2} is already known"
    redo
  end
  if count == 17  #loop stops when all 17 squares (sum of all squares that 5 ships occupy) have been hit
    puts
    puts 'Congratulations You Won!'
    print "Your score: #{moves}"
    break
  end
end


