module Home where

import String
import Website.ColorScheme as C
import Website.Skeleton (skeleton)
import Window
import JavaScript as JS

title = constant (JS.fromString "Library Design Guidelines")
foreign export jsevent "title"
  title : Signal JS.JSString

scene _ () w =
    let words' = width (min w 800) words in
    container w (heightOf words') middle words'

words = [markdown|
<style>
pre {
  background-color: white;
  padding: 10px;
  border: 1px solid rgb(216, 221, 225);
  border-radius: 4px;
}
li { padding: 4px; }
</style>

# Library Design Guidelines

These guidelines are meant to promote consistency and quality across all
Elm libraries. It is a collection of best practices that will help you
write better libraries and your users write better code with your library.

## Design for a concrete use case

Before you start writing a library, think about what your goal is.

* What is the concrete problem you want to solve?
* What would it mean for your API to be a success?
* Who has this problem? What do they want from an API?
* What specific things are needed to solve that problem?
* Have other people worked on this problem? What lessons can be learned from them?
  Are there specific weaknesses you want to avoid?

Actually think about these things. Write ideas on paper. Ask for advice
from someone you trust. It will make your library better. If you are doing
this right, you will have example code and a tentative API before you
start implementing anything.

## Avoid gratuitous abstraction

Some functional programmers like to make their API as general as possible.
This will reliably make your API harder to understand. Is that worth it?
What concrete benefits are users gaining? Does that align with the concrete
use case you have in mind for your library?

Abstraction is a tool, not a design goal. Unless abstraction is
making someones life easier, it is not a good idea. If you cannot
*demonstrate* why your abstraction is helpful, it is a problem with your API.

## Use semantic versioning

Read [this](http://semver.org/) and follow the rules. It makes everyone's life better.

## The data structure is always the last argument

Function composition works better when the data structure is the last argument:

```
getCombinedHeight = foldl (+) 0 . map .height
```

Folding also works better when the data structure is the last argument.
`foldl`, `foldr`, and `foldp` use an accumulator function where the
data structure is the last argument:

```haskell
-- Good API
lookup : String -> Dict String a -> Maybe a
selectedPeople = foldr lookup people ["Steve","Tom","Sally"]

-- Bad API
lookup : Dict String a -> String -> Maybe a
selectedPeople = foldr (flip lookup) people ["Steve","Tom","Sally"]
```

The order of arguments in fold is specifically intended to make this very
straight-forward: *the data structure is always the last argument*.

## Do not expose ADTs or record constructors

This makes it hard to extend things later. Prefer exposing functions to construct
these values.

## Naming

#### Give functions human readable names

Abbreviations are generally a silly idea for an API. Having an API
that is clear is more important than saving three or four characters
by dropping letters from a name.

Infix operators are not a substitute for human readable names.
They are impossible to Google for. They encourage users to not use
module prefixes, making it impossible to figure out what module they
came from. This makes them even harder to find. More on this later.

#### Module names should not reappear in function names

A function called `State.runState` is redundant and silly. More importantly,
it encourages people to use `import open State` which does not scale well.
In files with many `open` dependencies, it is essentially impossible to
figure out where functions are coming from. This can make large code
bases impossible to understand, especially if custom infix operators are
used as well. Repeating the module name actively encourages this kind of
unreadable code.

With a name like `State.run` the user is encouraged to disambiguate functions
with namespacing, leading to a codebase that will be clearer to people reading
the project for the first time.

#### Avoid infix operators

They should never take the place of a well-named human readable
function. In a large code base that is maintained by many people,
infix operators are typically a bad idea.

  * They are difficult to search for online.
  * They are difficult to search for in a codebase too because they are rarely
    prefixed with the module they were imported from.
  * They usually offer no insight into what they actually do. To the uninitiated,
    things like `(<*>)` and `(!?)` are meaningless.

Now lets assume you have a really great infix operator, an operator that actually
represents its meaning in a very direct way, like `(<~)`. In this case, it is still
recommended that you do not add the infix operator.

Okay, but lets say you want to do it anyway. One way to do it is to provide a
recommended set of infix operators at the end of your library documentation.
Experienced users can go see if they like them and define them if they really want.
That way the API can be nice and human readable *and* encourage its users to write code
that is nice and human readable.

Okay, but lets say you just don't care about recommendations and you have a great
infix operator. Add them in a separate module. When someone sees an infix operator
they are unfamiliar with, they can scan the imports for a `Whatever.Infix` module
and limit the scope of their annoying search for your dumb operator.

|]

main = skeleton [] scene (constant ())
