--[[
	
	Author: @XnLogicaL (@CE0_OfTrolling)
	Licensed under the MIT License.
	
	Custom brainf#ck++ interpreter (I have mental problems)
	TOKENS:
	  [<] - Moves the pointer to the left once
	  [>] - Moves the pointer to the right once
	  [+] - Incerements the pointers adress' value by 1
	  [-] - Decrements the pointers adress' value by 1
	  [,] - Does nothing
	  [.] - Prints the current pointers adress' value
	  ([) - Starts a while loop, executes everything until the closing bracket
	  (]) - Returns to the [ character if the pointers adress' value isnt 0
	  [/] - Starts and ends a comment
	  [*] - Prints the pointers raw adress
	  [#] - Prints the memory
	
	EXAMPLES:
	
	Hello World!:
	++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>
	---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>.
	
	Cat program:
	,[.,]
	
	Fibonacci sequence (up to 255):
	++++++++[->+<]>[[->+<]+>-]>.
	
	(Sorry for making the source code look like assembly lol)
	
]]--

local UTF8_CHARS = require(script.utf8_chars)
local MEMORY = {}
local POINTER_ADRESS = 1

local TOKENS = {
	["<"] = function(...)
		POINTER_ADRESS -= 1
	end,
	[">"] = function(...)
		POINTER_ADRESS += 1
	end,
	["+"] = function(...)
		MEMORY[POINTER_ADRESS] += 1
	end,
	["-"] = function(...)
		MEMORY[POINTER_ADRESS] -= 1
	end,
	[","] = function(...)
		
	end,
	["."] = function(...)
		local CHAR = UTF8_CHARS[MEMORY[POINTER_ADRESS]]
		if CHAR == nil then
			CHAR = "NULL"
		end
		print(CHAR)
	end,
	["["] = function(SOURCE: string, CHARPOS: number)
		local LOOP_INSTRUCTIONS = {}
		for INDEX = CHARPOS + 1, SOURCE:len() do
			local TOKEN = SOURCE:sub(INDEX, INDEX)
			if TOKEN == "]" then
				break
			end
			table.insert(LOOP_INSTRUCTIONS, TOKEN)
		end
		LOOP_INSTRUCTIONS = table.concat(LOOP_INSTRUCTIONS, "")
		while MEMORY[POINTER_ADRESS] ~= 0 do
			INTERPRETOR(LOOP_INSTRUCTIONS)
			if MEMORY[POINTER_ADRESS] == 0 then
				break
			end
			task.wait(0.0001)
		end
	end,
	["]"] = function(...)
		
	end,
	["*"] = function(...)
		print(POINTER_ADRESS)
	end,
	["/"] = function(SOURCE: string, CHARPOS: number)
		local END_POINT
		for INDEX = CHARPOS + 1, SOURCE:len() do
			local TOKEN = SOURCE:sub(INDEX, INDEX)
			
			if TOKEN == "/" then
				END_POINT = INDEX
				break
			end
		end
		if END_POINT == nil then
			SOURCE = SOURCE:sub(1, CHARPOS)
		else
			SOURCE = SOURCE:sub(1, CHARPOS) .. SOURCE:sub(END_POINT, SOURCE:len())
		end
	end,
	["#"] = function(...)
		print(MEMORY)
	end,
	[" "] = function(...)
		
	end,
}

function INITIALIZE_MEMORY(MEMORY: {}, MEM_SIZE: number)
	for i=1, MEM_SIZE do
		MEMORY[i] = 0
	end
end

function CLEAR_MEMORY(MEMORY: {any})
	table.clear(MEMORY)
end

function INTERPRETOR(SOURCE: string)
	for INDEX = 1, SOURCE:len() do
		local INSTRUCTION = SOURCE:sub(INDEX, INDEX)

		if TOKENS[INSTRUCTION] == nil then
			warn(("brainf#ck interpreter warning: invalid character [%s] at index %s"):format(INSTRUCTION, INDEX))
			continue
		end

		TOKENS[INSTRUCTION](SOURCE, INDEX)
		task.wait(0.0001)
	end
end

return function(SOURCE: string, MEM_SIZE: number)
	CLEAR_MEMORY(MEMORY)
	INITIALIZE_MEMORY(MEMORY, 100)
	return INTERPRETOR(SOURCE)
end
