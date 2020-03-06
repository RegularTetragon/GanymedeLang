# Ganymede
Ganymede is a language where procedures never return.
Ganymede is based on the language Io found in Dr. Raphael Finkel's book Advanced Programming Language Design.


## Ganymede Programs
All ganymede programs contain any number of declarations, followed by a procedure call, followed by a period. This single statement however can contain other statements. A statement is a procedure call, or a procedure definition.

## Expressions
There are few things in ganymede that can be evaluated. Those things are
* Procedure definitions
* Parametric definitions
* Identifiers
* Number literals
* String literals

## Procedure calls
A procedure call is an identifier followed by any number of arguments separated by a space.
Arguments must be atomic.

writeTwoStringsAndQuit "hello" "world"

is an example of a bare procedure call.

## Built in types
Types are first class
* String - represented by "string"
* Number - represented by "number"
* Procedure - Procedure types are represented by parentheses with a space separated argument list

## Built in procedures
* import :: string (T...)                       opens a Ganymede module and runs it immediately
* export :: (T...)                              returns content from a ganymede module.
* read :: (string)                              reads from standard in
* write :: string ()                            writes to standard out
* async :: () ()                                runs two procedures simultaneously
* open :: string ((string) (string ()))         opens a file and returns a read and write procedure for that file.
* shared :: T ((T) (T ()))                      creates a shared memory location between threads, and passes getters and setters to its given continuation
* channel :: T ((T) (T))                      creates a bounded buffer

## Constructors do return
There are 

## Semicolon operator: Building Procedures
The semicolon operator constructs a argumentless, anonymous, deeply bound procedure from the ";" to the end of the current block.

For example
write 3;
write 4;
terminate.

Is parsed into

write 3 (; write 4 (; terminate)).

The environment of the procedure is a closure bound at elaboration time.

It's important to not forget semicolons. It will not fail to parse, as in a C-like language, because they have
significant semantic meaning. Let's remove the first semicolon in our example and see what it gets parsed as:

write 3
write 4;
terminate.

This gets parsed as
write 3 write 4 (; terminate)
Which means "pass the arguments 3, write, 4, and (;terminate) into the "write" procedure". This will give an error which looks like:
"Too many parameters to parametric procedure 'write'"

## Arrow operator: Taking Parameters
A parametric procedure definition begins at an -> operator, followed by a number of formal parameters, followed by a 0 argument procedure.

For example:
-> x y;
write x;
write y;
terminate.

will get parsed as
-> x y (; write x (; write y (; terminate)))

This is an anonymous procedure which writes both it's arguments and then ends the program.
The arguments may be of any type, including other procedures:

-> x y continue;
write x;
write y;
continue.

All parameters are passed by value.

## Declarations
A declaration is a constant in the program. These declarations can be of any type, and are written as
declare \declarationName\ \declarationValue\

A common usage of declarations is to name procedures:

declare writeTwice -> str continue;
    write x;
    write y;
    continue.

## Blocks
Blocks are defined with curly braces. They create a argumentless procedure which can end before the block's enclosing area.
The "}" part of the block has an implicit semicolon after it.


{ is syntactic sugar for (;
} is syntactic sugar for );

Let's take async for example, which takes two procedures:

spawn {
    write "hi";
    terminate.
}
write "bye";
terminate.