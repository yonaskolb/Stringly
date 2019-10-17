# Stringly

Stringly generates an Apple `.string` file from a `yaml`,`json`, or `toml` file.

Having such an easily editable and nested structure is perfect for generating strings with https://github.com/SwiftGen/SwiftGen with the `structured-swift4` strings template

## Usage

```
stringly Strings.yml Localized.strings
```

## Example

`Strings.yml`:
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

or `Strings.toml`:
```toml
[auth]
emailTitle = "Email"
loginButton = "Log In"
passwordTitle = "Password"

[auth.error]
wrongEmailPassword = "Incorrect email/password combination"

[welcome]
title = "Hello %@"
```

Generated to `Localized.strings`:
```
"auth.emailTitle" = "Email";
"auth.loginButton" = "Log In";
"auth.passwordTitle" = "Password";

"auth.error.wrongEmailPassword" = "Incorrect email/password combination";

"welcome.title" = "Hello %@";
```

Then generation with [SwiftGen](https://github.com/SwiftGen/SwiftGen):
```sh
$ swiftgen strings --template structured-swift4 --output Strings.swift
```

Results in usage like this:
```swift
errorLabel.text = L10n.Auth.Error.wrongEmailPassword
welcomeLabel.text = L10n.Welcome.title("John")

```

## Future Directions
- Generate to other languages like Android `R.string` file
- Cross platform string substitutions
- Cross platform plural support
- Comments and other data for keys
