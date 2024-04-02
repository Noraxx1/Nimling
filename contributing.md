
# contributing
If you want to contribute, you will find a 'template.zip' in the releases section of GitHub.

That zip file contains `data.json` and `main.nim` files.

# data.json
The file will look something like:

```
{
"explanation": "",
"hint": ""
}
```


Copy code
This file contains the explanation and the hint. The explanation is the output of the `explanation` command in the **nimlings** console, while the hint is the same thing but with the `hint` command instead. You can set them to `None` if you don't want to add an explanation/hint.

If you need to write multiline explanations/hints, it will look a bit weird:
```
{
    "explanation": "This is the first line of the exercise,
while this is the second one",

    "hint": "None"
}
```


# main.nim

This file will contain the broken code you want the user to fix. There are a few keywords and rules while writing this:
- `# NOT DONE` on the first line is used to 'lock' the **nimlings** from passing to the next exercise without making the compiled successful interface appear. When you're making a new exercise, having this at the top of the file (so line 1) is required; otherwise, the exercise won't be counted as valid.
- `proc main()` a main function is not needed in Nim, but here in **nimlings**, we prefer having one, so please use it.

# how to write
We also have some keywords on how to write comments or explanations/hints for the user in general:
- `Note:` this is how you can write a note for the user.

# publishing an exercise

Let's say you have your exercise file ready; you need to put them in a folder with the name of your exercise,
then zip it and open an issue with the tag `exercise`.