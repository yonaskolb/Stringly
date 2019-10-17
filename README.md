# Stringly

Stringly generates an Apple `.string` file from a yaml/json file.

Having such an easily editable and nested structure is perfect for generating strings with https://github.com/SwiftGen/SwiftGen with the `structured-swift4` strings template

### Usage

```
stringly Strings.yml Localized.strings
```

Strings.yml
```yml
auth:
  loginButton: Log In
  passwordTitle: Password
  emailTitle: Email
  error:
    wrongEmailPassword: Incorrect email/password combination
welcome:
  title: Hello %@
```

Localized.strings
```
"auth.emailTitle" = "Email";
"auth.loginButton" = "Log In";
"auth.passwordTitle" = "Password";

"auth.error.wrongEmailPassword" = "Incorrect email/password combination";

"welcome.title" = "Hello %@";
```

### Future Direction
- Generate to other languages like Android `R.string` file
- Cross platform string substitutions
- Cross platform plural support
- Comments and other data for keys
