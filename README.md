CMD module
========


It is a very simple async os:cmd implementation.

There are several problems currently like impossibility to use commands like
"echo a && echo b" (result of first command will be returned) but I will fix it asap.

Also about future of the module:
Currently I want to add option to allow returning list of strings instead of 1 long result.
Any suggestions about "what else should be done" would be appreciated.

Usage:

```
Result = cmd:run(Command, Options).
```

Options is proplist. Values are:
timeout (Int)
Timeout for command execution. Exception will be thrown after it. Default: 5000
datatype (list|binary)
Return data type. Can be list ("returnvalue") or binary (<<"returnvalue">>). Default: list

Examples:

```
Whoami = cmd:run("whoami"). %% "chvanikoff"
```
```
Whoami_binary_string = cmd:run("whoami", [{datatype, binary}]). %% <<"chvanikoff">>
```

As you can see there is no newline (\n) at the end of the results. That's it: it's natural "cmd:run" behaviour cause
in most cases we don't need it but if you do - there's no problem to return it manually:

```
Whoami_with_nl = lists:flatten([cmd:run("whoami") | "\n"]). %% "chvanikoff\n"
```
or even
```
Whoami_with_nl2 = cmd:run("whoami") ++ "\n". %% "chvanikoff\n"
```

