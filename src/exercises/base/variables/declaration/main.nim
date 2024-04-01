# NOT DONE


# Is reccomended for you to first read the code,then to run the explain command.


var name = ""  # Creates a string type variable,and sets its content.
var age : int  # Initializes an age variable.

proc main() =
    age = "a"

    echo "Hello:" & name # the and(&) simble is used to use multiple argouments in a function,whe used it to print multiple text in a `echo` function
    echo "Your age is: " & $age # The dollar symbol ($) transforms an integer to a string, making it possible to print a string followed by an integer with an `echo`, or else we would get a type mismatch.

    
main()