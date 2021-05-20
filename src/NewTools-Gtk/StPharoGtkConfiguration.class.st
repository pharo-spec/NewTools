"
I am the configuration for Pharo IDE for Gtk backend. 
I will install the appropriate theme for each platform (macOS or windows, in linux I will accept default for now).
I will install additional styles needed for the platform (e.g. font style for code).
"
Class {
	#name : #StPharoGtkConfiguration,
	#superclass : #SpGtkConfiguration,
	#category : #'NewTools-Gtk'
}

{ #category : #accessing }
StPharoGtkConfiguration >> commonStyle [

	^ '
/* compact toolbar */
toolbar { font-size: 0.6em }
toolbar toolbutton > button { padding: 2px; margin: 2px }

.dim { color: LightSlateGrey }
.codePopover,  .codePopover text { 
	background-color: transparent;
}
.scrollbarPopoverLarge { min-height: 350px }
'
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureGeneral: anApplication [ 

	self addCSSProviderFromString: self commonStyle.
	anApplication 
		propertyAt: #syntaxHighlightTheme
		put: self syntaxHighlightThemeName
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureOSX: anApplication [

	self installTheme: self macThemeName.
	self addCSSProviderFromString: '
.code { font: 12pt "Monaco" }
'
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureUnix: anApplication [

	self unixThemeName ifNotNil: [ :aName | self installTheme: aName ].
	self addCSSProviderFromString: '
.code { /* font: 10pt "Source Code Pro" */ }
'
]

{ #category : #configuring }
StPharoGtkConfiguration >> configureWindows: anApplication [

	self installTheme: self windowsThemeName.
	self addCSSProviderFromString: '
.code { font: 10pt "Microsoft Sans Serif" }
'
]

{ #category : #accessing }
StPharoGtkConfiguration >> macThemeName [
		
	^ 'Sierra-light'
]

{ #category : #accessing }
StPharoGtkConfiguration >> syntaxHighlightThemeName [

	^ 'Blue'
]

{ #category : #accessing }
StPharoGtkConfiguration >> unixThemeName [

	^ nil "'Adwaita'"
]

{ #category : #accessing }
StPharoGtkConfiguration >> windowsThemeName [

	^ 'Windows-10-master'
]
