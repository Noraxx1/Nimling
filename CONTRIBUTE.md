
## Contributing
If you would like to contribute and help us develop Nimlings, that's great! We really appreciate your effort. Let's get started. 
___
### Downloading the template archive
In the *Github/Releases* section of this repository you will find an archive called `template.zip`. It contains all basic files for a normal Nimlings exercise.
___
More detailed, this `.zip` contains both `data.json` & `main.nim` files. Main nim file is where the broken code actually is located, meanwhile the JSON file is used to store an explanation, hint and a desired output for the exercise. The desired output is what the program is supposed to print in the end. 
___
That's how the `data.json` file looks:
```
{
"explanation": "",
"hint": "",
"desired_output": ""
}
```
The explanation is being printed to the user when they use `explain` command in the nimlings terminal itself. The hint will be printed out if the user uses `hint` command, which should be self-explanatory. The `desired_output` is the output that the nim program (the exercise) will give. Note that it's the 
___
The `desired_output` needs to be **contained** inside of the exercise's output. The output can contains other values, and it's not like the "equal sign". 

**TL;DR**: The `desired_output ≠ exercise's output` but the `desired_output` needs to be inside of `exercise's output`.
___
### Important rules & notes about `main.nim`
Remember that the `main.nim` file will contain the broken code you want the user to fix. There are some rules that we need you to follow when creating an exercise:
___
1. `# NOT DONE` line (which is a nim comment) is used to kind of comminucate with the nimlings terminal program. It says that the exercise has not been completed. This line is needed to tell nimlings to not go to the next exercise after the `run` command. **Note:** this comment has to be located on the very first line of the `main.nim` file; otherwise it wouldn't count.
2. Unlike most of programming languages, the main function (we are talking about `proc main()`) is not required while developing in **Nim**. However, here in **Nimlings** we prefer using one. It makes the code more readable and clear what is and what is not being done. It's also **required** for the exercise to count, as otherwise nimlings wouldn't know what to run and would give an error.
___

### How do I publish my exercise/add it to nimlings?
Let's say that you have fully completed a well-done exercise that is ready to be published. The process is simple: you need to get all the files together and zip them in an archive (`.zip`). Afterwards, on *Github/Issues* page of this repository you would need to open an **issue* with the tag `"exercise"`. **We will review your exercise and chances are, it's going to be added to nimlings!**