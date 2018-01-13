# pn
Polish notation(s) converter using Flex/Bison

### Usage

Example input file:

```
pre -> in: * 3 + 4 5
in -> post: 25 / 5 + 3 + 4 / 2
```

will output:
```
3 * (4 + 5) = 27
25 5 / 3 + 4 2 / + = 10
```

On the first line, the program takes an expression in prefix (Polish) notation
and outputs it in infix (Common, parenthesized) notation. The second line was
converted from infix notation to postfix (Reverse polish) notation.
