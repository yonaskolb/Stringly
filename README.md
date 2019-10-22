# Stringly

Stringly generates type safe localization files from a source `yaml`,`json`, or `toml` file. At the moment only outputs for Apple platforms are supported

- ✅ **Multi-language** support
- ✅ **Named placeholders**
- ✅ **Plural** support
- ✅ Compile safe **Swift** accessors

## Usage

See help
```
stringly help
```
To generate all files in all languages
```
stringly generate Strings.yml
```
To generate a single file in a certain langage
```
stringly generate-file Strings.yml Strings.strins --language de
```

## Example

Given a source `Strings.yml`:
```yml
auth: # grouping of strings
  loginButton: Log In # If you don't specify a language it defaults to a base language
  emailTitle: Email
    en: Email # specifying a language
  passwordTitle: 
    en: Password
    de: Passwort # multiple languages
  error: # infinitely nested groups
    wrongEmailPassword: Incorrect email/password combination
home:
  title: Hello ${name} # this is a placeholder. Without a type defaults to %@ on apple platforms
  postCount: "Total posts: ${postCount:d}" # the placeholder now has a type %d
  articles: # this is a pluralized string
    en: You have ${articleCount:d} # placeholder will be replace with pluralization
    en.articleCount: # supports pluralizing multiple placeholders in a single string
      none: no articles
      one: one article
      other: ${articles:d} articles
```

This generates `.swift`, `.strings`, and `.stringsdict` files for multiple languages.

The Swift file then allows usage like this:
```swift
errorLabel.text = Strings.auth.error.wrongEmailPassword
welcomeLabel.text = Strings.home.title(name: "John")
postsLabel.text = Strings.home.postCount(postCount: 10)
articleLabel.text = Strings.home.articles(articleCount: 4)
```

## Future Directions
- Comments and other data for keys
- Generate to other languages and platforms like Android `R.string` file or translation specific files
- Importing of translation files
