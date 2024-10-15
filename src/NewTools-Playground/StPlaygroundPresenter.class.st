"
It is useful to explore ideas or learn something before writing it to a more definitive place.
In older versions of Pharo, this tool was known as Workspace.

The idea of a playground is not new in smalltalk systems and many other dynamic languages have implemented in one way or another some features of it, usually through a REPL, which shares much of a playground functionality. 

Some of the things a playground can do for you: 

- it can execute code (and print its results).
- it can debug some piece of code you just typed.
- it can search references, implementors and senders
- it can store variables (both locally or shared to all playgrounds).

!! Opening:
You usually will open a playground by choosing it from the Pharo menu (Playground option), but it can also be opened programatically. 
[[[language=Smalltalk
StPlayground open.
StPlayground openContents: 'Some scripting'
]]]

!! Using the playground
Most of the functionalities a playground does can be found in the context menu of it (==<meta+t>== or right button click), and we will not explain in detail each of them. But there are some usages that may requirse some more documentation than ""self discovery"". Here are some hints you may find useful: 

!!! Keyboard friendly
There is a shortcut, ==<meta+t>==, that will show the context menu corresponding to the playground. Additionaly, there will be entries to control also what you can find in the toolbar or status bar. This redundancy is intentional and it will allow the user to navigate through all the options of the playgrounds without needing a secondary device (which, of course, can be used anyway if desired).

!!! The print it popover
If you try to print results of a computation, you will see that you receive a popover with the results of the execution (e.g. ==21*2== will show a popover with the ==42== number). There are some other things you can do with this popover besides just dismiss it (pressing ==<esc>==, ==<backspace>== or just focusing somewhere else).
You can also: 

- press ==<cr>== to print the result into your playground (it will be shown enclosed with ""quotation marks"", as a comment.
- press ==<meta+i>== to inspect the result.

!!! The bindings window
The bindings window will be shown by selecting the ""Bindings"" option of the context menu or toolbar.
You will see the variables panel and an inspector allowing you to explore/modify the values of a variable. There is also a context menu in the variables list that will allow you some other options. One interesting option you will see is the ""make variable shared"" option. This option will make the variable common to all playgrounds. It is an easy way to explore some posibilities in a separated space, not modifying what you already have there.

See *class:StPlaygroundBindingsPresenter*

!!! The pages window
The pages window will be shown by selecting the ""Pages"" option of the context menu or toolbar.
This window will list all playgrounds pages stored in the playground cache directory. You can choose any playground edited in any moment and load it into your playgroud.

See *class:StPlaygroundPagesPresenter*

"
Class {
	#name : 'StPlaygroundPresenter',
	#superclass : 'StInspectorPresenter',
	#classVars : [
		'CacheDirectory'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'accessing' }
StPlaygroundPresenter class >> cacheDirectory [
	
	^ CacheDirectory ifNil: [ self defaultCacheDirectory ]
]

{ #category : 'accessing' }
StPlaygroundPresenter class >> cacheDirectory: aDirectory [
	
	CacheDirectory := aDirectory ensureCreateDirectory
]

{ #category : 'private' }
StPlaygroundPresenter class >> defaultCacheDirectory [
	
	^ (FileLocator localDirectory / 'play-cache') ensureCreateDirectory
]

{ #category : 'accessing' }
StPlaygroundPresenter class >> defaultExtent [

	^ (600@400)
]

{ #category : 'accessing' }
StPlaygroundPresenter class >> defaultTitle [ 

	^ 'Playground'
]

{ #category : 'class initialization' }
StPlaygroundPresenter class >> initialize [

	"Make playground active by default"
	self register
]

{ #category : 'world menu' }
StPlaygroundPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>
	(aBuilder item: #Playground)
		parent: #InputOutput;
		action: [ Smalltalk tools workspace open ];
		order: 1;
		keyText: 'o, p';
		help: 'A window used as a scratchpad area where fragments of Pharo code can be entered, stored, edited, and evaluated.';
		iconName: #workspace
]

{ #category : 'instance creation' }
StPlaygroundPresenter class >> open [

	<script>
	^ self new open
]

{ #category : 'instance creation' }
StPlaygroundPresenter class >> openContents: aString [
	"Open a new workspace with the given contents. It looks better when aString is code since the style is applied"

	^ self new
		contents: aString;
		open
]

{ #category : 'tools registry' }
StPlaygroundPresenter class >> register [
	"Add ourselves to registry. See [Smalltalk tools]" 
	<script>

	self registerToolsOn: Smalltalk tools
]

{ #category : 'tools registry' }
StPlaygroundPresenter class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 

	registry register: self as: #workspace

]

{ #category : 'settings' }
StPlaygroundPresenter class >> settingsOn: aBuilder [
	<systemsettings>

	(aBuilder setting: #cacheDirectory)
		parent: #pharoSystem;
		type: #Directory;
		default:  self defaultCacheDirectory;
		target: StPlaygroundPresenter;
		description: 'The path to the local Playground cache that stores all Playground scripts in ph files';
		label: 'Local Playground cache directory'.
]

{ #category : 'accessing' }
StPlaygroundPresenter >> contents: aString [ 

	self firstPage contents: aString
]

{ #category : 'api - focus' }
StPlaygroundPresenter >> defaultKeyboardFocus [

	^ self firstPage
]

{ #category : 'actions' }
StPlaygroundPresenter >> loadPage: aFileReference [

	self firstPage loadPage: aFileReference
]

{ #category : 'private - factory' }
StPlaygroundPresenter >> newDefaultPlaygroundPage [

	^ StPlaygroundPage new
]

{ #category : 'private - factory' }
StPlaygroundPresenter >> newInspectorFor: aModel [
	| isPlayground inspector |

	isPlayground := millerList pages isEmpty and: [ aModel isNil ].

	inspector := super newInspectorFor: (isPlayground 
		ifTrue: [ self newDefaultPlaygroundPage ]
		ifFalse: [ aModel ]).
		
	isPlayground ifTrue: [ self prepareInspectorAsPlayground: inspector ].
		
	^ inspector
]

{ #category : 'accessing' }
StPlaygroundPresenter >> page [

	^ self firstPage page
]

{ #category : 'private' }
StPlaygroundPresenter >> prepareInspectorAsPlayground: inspector [

]

{ #category : 'private - stepping' }
StPlaygroundPresenter >> startProcessing [
	
	"A playground does not steps, do nothing"
]

{ #category : 'private - stepping' }
StPlaygroundPresenter >> stopProcessing [
	
	"A playground does not steps, but it needs to force a flush of last changes"
	self firstPage ensureContentsFlushed
]

{ #category : 'initialization' }
StPlaygroundPresenter >> windowIcon [
	
	^ self application iconNamed: #workspace
]

{ #category : 'initialization' }
StPlaygroundPresenter >> windowTitle [

	^ self class defaultTitle
]
