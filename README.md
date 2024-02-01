# lua-brainfuck++
A brainfuck(++) interpretor made entirely in lua (help me)
What is brainfuck++ you may ask?
- Well, it's just brainfuck but with extra features lol

# Syntax
There's no syntax lol

# Tokens
- [<] - Moves the pointer to the left once
- [>] - Moves the pointer to the right once
- [+] - Incerements the pointers adress' value by 1
- [-] - Decrements the pointers adress' value by 1
- [,] - Does nothing
- [.] - Prints the current pointers adress' value
- ([) - Starts a while loop, executes everything until the closing bracket
- (]) - Returns to the [ character if the pointers adress' value isnt 0
- [/] - Starts and ends a comment
- [*] - Prints the pointers raw adress
- [#] - Prints the memory
