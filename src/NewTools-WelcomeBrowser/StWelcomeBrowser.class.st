"
A welcome browser for the Pharo system.

"
Class {
	#name : 'StWelcomeBrowser',
	#superclass : 'StPresenter',
	#instVars : [
		'contentPanel',
		'millerList',
		'paginator'
	],
	#category : 'NewTools-WelcomeBrowser-Base',
	#package : 'NewTools-WelcomeBrowser',
	#tag : 'Base'
}

{ #category : 'accessing' }
StWelcomeBrowser class >> defaultPreferredExtent [

	^ 720@550
]

{ #category : 'accessing' }
StWelcomeBrowser class >> logo [

	^ ImageMorph withFormSet: (self iconFormSetNamed: #pharoBig)
]

{ #category : 'world menu' }
StWelcomeBrowser class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'Welcome to Pharo')
		parent: #PharoHelp;
		order: 1;
		action: [ self open ];
		iconName: #smallPharo;
		help: 'Welcome window for Pharo'
]

{ #category : 'instance creation' }
StWelcomeBrowser class >> open [
	<script>
	
	(self newApplication: StPharoApplication current) open
]

{ #category : 'instance creation' }
StWelcomeBrowser class >> openForRelease [
	<script>
	| window |
	
	window := self new open.
	"HACK: reset extent and position because it seems to not being taken 
	 into account before opening. Using directly the morphic widget, as we 
	 know we are still in morphic world."
	window withAdapterDo: [ :anAdapter | 
		anAdapter widget
			position: (((self environment classNamed: #OSWorldRenderer) defaultExtent - self windowExtent) / 2) asIntegerPoint;
			extent: self windowExtent ]
]

{ #category : 'instance creation' }
StWelcomeBrowser class >> windowExtent [

	^ (720@550)
]

{ #category : 'private' }
StWelcomeBrowser >> addPresenter: aPresenter [

	millerList addPresenter: aPresenter.
	paginator addPage: aPresenter
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> changesContent [

	^ '# Pharo 13 changes overview

A large international community of developers worked hard to prepare a new release of the Pharo platform.

## Highlights
### Tools
- Spec Tools remembering their size
- Microdown enhancements
- HDPI support
- Zoomable UI 
- New list, tables and trees, allowing any presenter as their content
- Better source code text navigation and edition
- New Process Browser
- New Transcript (introducing also the Object Transcript)
- Organic window manager 

### System 
- Better refactorings UX Cleaner leaner code logic
- More robust and faster halt implementation
- Debug points to enhance the debugging experience
- Clean-ups
   
### Virtual machine
- Async IO using epoll on unixes
- Faster byte array / string comparisons
- Improve Windows support for non ASCII filenames
- FreeBSD support
- Update SDL2 version in OSX (Intel & Apple)
- Minimal MacOS version required raised to MacOS 11 and above

## Status
Current Pharo development status:
1. 379 forks on GitHub
2. 922 issues closed since Pharo 12
3. 698 Pull requests processed since Pharo 12, not counting separately managed projects:
- [http://github.com/pharo-spec/NewTools](http://github.com/pharo-spec/NewTools)
- [http://github.com/pharo-spec/Spec](http://github.com/pharo-spec/Spec)
- [http://github.com/pharo-vcs/Iceberg](http://github.com/pharo-vcs/Iceberg)
- [https://github.com/pharo-graphics/Roassal](https://github.com/pharo-graphics/Roassal)
- [http://github.com/pillar-markup/Microdown](http://github.com/pillar-markup/Microdown)
- [http://github.com/pillar-markup/BeautifulComments](http://github.com/pillar-markup/BeautifulComments)
- [https://github.com/pharo-project/pharo-vm](https://github.com/pharo-project/pharo-vm)

## Changelog

The complete list of changes can be viewed on a weekly basis [here](https://github.com/pharo-project/pharo-changelogs).'
]

{ #category : 'accessing - labels' }
StWelcomeBrowser >> changesLabel [

	^ 'Changes in Pharo ', self version
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> contributorContent [

	^ '## Contributors
We always say Pharo is yours. It is yours because we made it for you, but most importantly, because it is made by the invaluable contributions of our great community (yourself).  

A large community of people from all around the world contributed to Pharo 13.0 by making pull requests, reporting bugs, participating in discussion threads, providing feedback and more. If you want to join us and contribute as well please check [https://pharo.org/contribute](https://pharo.org/contribute) 

Thank you all for your contributions!  

## Pharo Association

The Pharo association''s goal is to let individuals support the promotion and development of Pharo. If you want to support us and join then visit

- [https://association.pharo.org](https://association.pharo.org)

## Pharo Consortium

As a company or organization you might want to become a consortium member you help promote Pharo. The consortium promotes Pharo by supporting conferences, books, videos, exhibitions, and conference participation.

- [https://consortium.pharo.org](https://consortium.pharo.org)
'
]

{ #category : 'layout' }
StWelcomeBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: millerList;
		add: (SpBoxLayout newLeftToRight 
				hAlignCenter;
				add: paginator;
				yourself) 
			expand: false;
		yourself
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> helpContent [

	^ '### Help

A compendium of Pharo documentation can be found at: 

[http://pharo.org/documentation](http://pharo.org/documentation)

There you can find:
- Pharo books: [http://books.pharo.org](http://books.pharo.org)
- Screencasts: [https://www.youtube.com/@Pharo-projectOrg](https://www.youtube.com/@Pharo-projectOrg)
- Presentations: [http://www.slideshare.net/pharoproject/](http://www.slideshare.net/pharoproject/)

### Conferences
Conferences are unique event where you can meet other Pharoers and Smalltalkers, discover latest advances, and share your experience.

- [Pharo days](https://days.pharo.org)
- [ESUG Website](https://esug.github.io)
- [ESUG - Video channel](https://www.youtube.com/@esugboard)
- [FAST Foundation](https://www.fast.org.ar)
- [FAST - Video channel](https://www.youtube.com/@FASTFoundation)
- FAST - Smalltalks [2022](https://smalltalks2022.fast.org.ar/), [2023](https://smalltalks2023.fast.org.ar/), [2024](https://smalltalks2024.fast.org.ar/) (soon)
'
]

{ #category : 'accessing - labels' }
StWelcomeBrowser >> helpLabel [

	^ 'Getting Help'
]

{ #category : 'initialization' }
StWelcomeBrowser >> initializePresenters [

	self addStyle: 'welcome'.

	millerList := self instantiate: SpMillerColumnPresenter.
	millerList  
		withoutHorizontalScrollBar;
		visiblePages: 1;
		spacing: 5.
		
	paginator := SpPaginatorPresenter new.
	paginator visiblePages: 1.
	paginator chainTo: millerList.
	paginator withoutResizingEdges
]

{ #category : 'initialization' }
StWelcomeBrowser >> initializeWindow: aWindowPresenter [
	
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		bindKeyCombination: Character arrowRight asKeyCombination toAction: [ self selectNext ]; 
		bindKeyCombination: Character arrowLeft asKeyCombination toAction: [ self selectPrevious ]
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> learnContent [

	^ '# Learn Pharo
  
### Getting help

Pharo has a vibrant community that shares knowledge in different ways: 

- The Pharo Users mailing list: [https://lists.pharo.org/list/pharo-users.lists.pharo.org](https://lists.pharo.org/list/pharo-users.lists.pharo.org)
- The Pharo Discord server: [https://discord.gg/QewZMZa](https://discord.gg/QewZMZa)

You can find more information, lists to browse/suscribe and places to share code at: 

[http://pharo.org/community](http://pharo.org/community)

### Using ProfStef
You can learn Pharo by clicking on the following expression: 

```pharoeval
ProfStef go.
```
'
]

{ #category : 'private' }
StWelcomeBrowser >> newContainerTopic [ 

	^ self instantiate: StWelcomeTopicContainerPresenter
]

{ #category : 'private' }
StWelcomeBrowser >> newMicrodownTopic [ 

	^ self instantiate: StWelcomeTopicMicrodownPresenter
]

{ #category : 'initialization' }
StWelcomeBrowser >> newTopicFrom: aTopic [

	^ self 
		instantiate: StWelcomeTopicPresenter 
		on: aTopic
]

{ #category : 'private' }
StWelcomeBrowser >> newTopicTitle: aTitle contents: aString [
	
	^ self newMicrodownTopic 
		title: aTitle;
		contents: aString;
		yourself
]

{ #category : 'private' }
StWelcomeBrowser >> newTopicTitle: aTitle presenterClass: aClass [
	
	^ self newContainerTopic 
		title: aTitle;
		contentPresenter: aClass new;
		yourself
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> resourceContent [

	^ '### Follow the MOOC

Pharo has an excellent MOOC (Massive Open Online Course). You can find more information here: 

[http://mooc.pharo.org](http://mooc.pharo.org)

Check the testimonies: they are great and fun. Additionally there is a new MOOC on 
"Advanced Object-Oriented Design and Development with Pharo" available

[https://advanced-design-mooc.pharo.org](https://advanced-design-mooc.pharo.org)

### Books

There are several free Pharo books that can be download here: 

[http://books.pharo.org](http://books.pharo.org)

A very interesting starting point would be looking into the "Updated Pharo by Example" free book. It is based on Pharo 9.0, so using this version is recommended to learn.

You can find the book here: [https://github.com/SquareBracketAssociates/PharoByExample9](https://github.com/SquareBracketAssociates/PharoByExample9)
and you can order a copy here: [Pharo 9 by example on Amazon](https://www.amazon.com/Pharo-example-Technology-Collection/dp/2322394106/)

Many of the Pharo books and bookolets are available in [https://github.com/SquareBracketAssociates](https://github.com/SquareBracketAssociates) and you can contribute to them.'
]

{ #category : 'private' }
StWelcomeBrowser >> select: aTopic [

	aTopic ifNil: [ 
		contentPanel text: ''.
		^ self ].

	self flag: #HACK. "I need to select an interval to force the text to 
	be at the beginning, otherwise it will show the last part"
	contentPanel 
		documentFromString: aTopic value; 
		selectionInterval: (1 to: 0)
	
]

{ #category : 'private' }
StWelcomeBrowser >> selectNext [ 

	(paginator selectedPage = millerList pages size) ifTrue: [ ^ self ].
	self selectPage: paginator selectedPage + 1
]

{ #category : 'private' }
StWelcomeBrowser >> selectPage: aNumber [

	paginator selectPage: aNumber.
	(millerList pages at: paginator selectedPage) takeKeyboardFocus
]

{ #category : 'private' }
StWelcomeBrowser >> selectPrevious [

	paginator selectedPage = 1 ifTrue: [ ^ self ].
	self selectPage: paginator selectedPage - 1
]

{ #category : 'accessing - labels' }
StWelcomeBrowser >> setupLabel [

	^ 'Quick Setup'
]

{ #category : 'private' }
StWelcomeBrowser >> topics [

	^ {
	self newTopicTitle: self welcomeLabel contents: self welcomeContent.
	self newTopicTitle: self helpLabel presenterClass: StWelcomeSetupPresenter.
	"self newTopicTitle: self setupLabel contents: self setupContent."
	self newTopicTitle: self helpLabel contents: self learnContent.
	self newTopicTitle: self helpLabel contents: self resourceContent.  	
	self newTopicTitle: self helpLabel contents: self helpContent. 
	self newTopicTitle: self changesLabel contents: self changesContent.
	self newTopicTitle: self helpLabel contents: self contributorContent.  
	}
]

{ #category : 'initialization' }
StWelcomeBrowser >> updatePresenter [
	| topics |

	topics := self topics.
	topics withIndexDo: [ :each :index |
		self addPresenter: (each
			hasPrevious: index > 1 hasNext: index < topics size;
			whenNextDo: [ self selectNext ];
			whenPreviousDo: [ self selectPrevious ];
			yourself) ].
	self selectPage: 1
]

{ #category : 'private' }
StWelcomeBrowser >> version [

	^ SystemVersion current major asString
]

{ #category : 'accessing - contents' }
StWelcomeBrowser >> welcomeContent [

	^ '# Welcome to Pharo ' , self version , '

![StWelcomeBrowser class](pharo:///StWelcomeBrowser/logo)

Welcome to Pharo, an immersive live programming environment.

Pharo is a pure object-oriented programming language and a powerful environment, focused on simplicity and immediate feedback (think IDE and OS rolled into one).

For more information, please visit here: [http://pharo.org](http://pharo.org)'
]

{ #category : 'accessing - labels' }
StWelcomeBrowser >> welcomeLabel [

	^ 'Welcome to Pharo ', self version
]

{ #category : 'accessing' }
StWelcomeBrowser >> windowExtent [

	^ 500@500
]

{ #category : 'accessing' }
StWelcomeBrowser >> windowTitle [

	^ 'Welcome'
]
