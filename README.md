# Ganymede
Ganymede is a language where procedures never return.
Ganymede is based on the language Io found in Dr. Raphael Finkel's book Advanced Programming Language Design.


## Ganymede Programs
All ganymede programs contain a single statement. This single statement however can contain other statements. A statement is a procedure call, or a procedure definition.

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
terminate

will get parsed as
-> x y (; write x (; write y (; terminate)))

This is an anonymous procedure which writes both it's arguments and then ends the program.
The arguments may be of any type, including other procedures:

-> x y continue;
write x;
write y;
continue

All parameters are passed by value.

### Syntactic Sugar
Because a continue is so common, and when used tends to involve nesting, the => operator is provided. The => operator implicitly adds a "continue" parameter, and must be closed using a ".", these dots must line up.

```ganymede
=> x y;
    + x y -> z;
    * x z -> w;
    continue w.
```

This is useful for functions like spawn, reducing the need for parentheses.

```ganymede
spawn => thread;
    get thread "name" -> name;
    write name.

otherStuffDownHere
```
## Default Environment

### let :: T (T)
calls a continuation immediately with the value passed in.

### import :: string (T...)
opens a Ganymede module and runs it immediately.

### continue :: (T...)
returns control to the importing module. If this is the top level
the program will exit.

### read :: (string)
reads a line from standard in, passes the result into the continuation

### write :: string ()
writes to standard out

### spawn :: (thread) ()
runs the given procedure in a new thread.

### open :: string ((string) (string ()))
opens a file and returns a read and write procedure for that file.