"
I am a helper browser that contains an explanation of what the rewrite rule are and how their syntax works.
"
Class {
	#name : 'StRewriterHelpBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'morphPresenter'
	],
	#category : 'NewTools-RewriterTools-Help',
	#package : 'NewTools-RewriterTools',
	#tag : 'Help'
}

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> basicPatterns [

	^ '(\`) BASIC PATTERN NODES

Code prefixed with a backtick character (\`) defines a pattern node. A pattern node can be a
variable or a literal:

`node asString

that will match message asString sent to any receiver.
It can be a message:

Smalltalk globals `message

that will match any unary message sent to `Smalltalk globals`.
It can also be a method itself:

`method
	^ nil

that will match any method which returns nil.
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> blockPatterns [

	^ '(`{ }) BLOCK PATTERN NODES

These are the most exotic of all the nodes. They match any AST nodes like a list pattern
and test it with a block. The syntax is similar to the smalltalk block, but curly braces
are used instead of square brackets and as always the whole expression begins with a backtick.
Consider the following example:

`{ :node | node isVariable and: [ node isGlobal ] } become: nil

this pattern will match a message #become: with an attribute nil, where the receiver is a
variable and it is a global variable.

There is also a special case called wrapped block pattern node which has the same syntax and
follows a normal pattern node. In this case first the node will be matched based on its
pattern, and then passed to the block. For example:

`#arr `{ :node | node isLiteralArray } asArray

is a simple way to detect expression like `#(1 2 3) asArray`.
In this case first `#(1 2 3)` will be matched by the literal node and then tested by the block.
'
]

{ #category : 'api' }
StRewriterHelpBrowserPresenter class >> getParsedText [

	^ String streamContents: [ :stream |
		stream << self patternCodeIntro << String cr
			<< self basicPatterns << String cr
			<< self literalPatterns << String cr
			<< self statementPatterns << String cr
			<< self listPatterns << String cr
			<< self blockPatterns << String cr
			<< self namingImportant << String cr
			<< self whatNext << String cr
			<< self issues << String cr
			<< self thanks]
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> issues [

	^ 'ISSUES?

 If you found any issues you can submit them here:

[https://github.com/jordanmontt/RewriteTool-Spec2/issues](https://github.com/jordanmontt/RewriteTool-Spec2/issues)
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> listPatterns [

	^ '(\`@) LIST PATTERN NODES

To have complete flexibility there is the possibility to use an at sign `@` before the name
of a pattern node which turns the node into a `list pattern node`. These nodes can match more
than a single entity. For example:

`@expr isPatternVariable

will match both messages

1 isPatternVariable

and

ast statement first isPatternVariable.

but in the second case `\`@expr` will represent `ast statement first`. These pattern nodes
will also match block definitions.

With message and method list nodes one can match any number of keywords and parameters.
An expression:

Smalltalk globals `@message: `@args

will match any message (including) unary sent to `Smalltalk globals` and `\`@args` will be
mapped to the list of arguments.

Disclaimer: you may write an expression with just `args` instead of `\`@args`.
But, following the list pattern grammar makes it easier to read.

Similarly you can match a list of temporary variables:

`@method: `@args
	| `temp `@temps |

This will match any method with one or more temporary variables and without any statement.
The first temporary variable will be mapped to `\`temp` the rest ones — to `\`@temps`.

Finally you can have a list of statements:

[ `.@Statements.
	`var := `@object ]

this expression will match a block which has an assignment of an expression to a variable as a
last statement. It can be preceded by any number of other statement (including 0).

The list patterns does not make any sense for literal nodes i.e. `\`#@literal`.

P.S. In the end it does not matter whether you will write `\`.@Statement` or `\`@.Statement`.
But I like to put `@` closer to the variable name as the character is larger itself and the
name looks nicer this way.
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> literalPatterns [

	^ '(\`\#) LITERAL PATTERN NODES

For variables backtick can be followed by hash to enforce that matched receiver will be a literal:

`#literal asArray
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> namingImportant [

	^ 'NAMING IS IMPORTANT

The pattern nodes are so that you can match anything in their place. But their naming is also
important as the code gets mapped to them by name. For example:

`block value: `@expression value: `@expression

will match only those “value:value:” messages that have exactly the same expressions as both
arguments. It is like that because we used the same pattern variable name.
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> patternCodeIntro [

	^ 'PATTERN CODE INTRODUCTION

Pattern code is very similar to ordinary Smalltalk code, but allows to specify some “wildcards”.
The purpose is fairly simple. Imagine that you have a piece of code:

car isNil ifTrue: [ ^ self ].

You can of course compare it with the same piece of code for equality, but wouldn''t it be cool
if you could compare something similar, but ignore the fact that the receiver is named `car`?
With pattern rules you can do exactly that. Consider the following code and notice the
backtick before car:

`car isNil ifTrue: [ ^ self ].

Now this expression can match any other expression where `isNil ifTrue: [ ^ self ]` is sent
to any variable (or literal). With such power you can find all the usages of `isNil ifTrue:`
and replace them with `ifNil`.

The following sections will go over different kinds of wildcards (pattern nodes).
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> statementPatterns [

	^ '(\`.) STATEMENT PATTERN NODES

Backtick can be followed by a period to match statements. For example:

`var
	ifTrue:  [ `.statement1 ]
	ifFalse: [ `.statement2 ]

will match an `ifTrue:ifFalse:` message send to any variable, where both blocks have
only one statement each.
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> thanks [

	^ '

Thanks to Yuriy Tymchuk for his tool MatchTool that we are using in this set of tools.
Also thanks to him for writing this help description.
	'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter class >> whatNext [

	^ 'WHAT IS NEXT?

At the moment you can create quality rules that use pattern expression to detect and even
automatically fix violations.

Especially read: `Rules > Creating Rules > Special Rules > ReNodeMatchRule`
'
]

{ #category : 'accessing' }
StRewriterHelpBrowserPresenter >> createTextMorph [

	^ RubScrolledTextMorph new
		  setText: self class getParsedText;
		  in: [ :this | this textArea readOnly: true ];
		  yourself
]

{ #category : 'layout' }
StRewriterHelpBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: morphPresenter;
		  yourself
]

{ #category : 'initialization' }
StRewriterHelpBrowserPresenter >> initializePresenters [

	morphPresenter := self newMorph
		morph: self createTextMorph;
		yourself.
	morphPresenter addStyle: 'bgOpaque'
]

{ #category : 'initialization' }
StRewriterHelpBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Rewrite rules syntax help';
		initialExtent: 570 @ 500;
		askOkToClose: false
]
