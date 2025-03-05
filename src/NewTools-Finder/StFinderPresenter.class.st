"
I am the presenter for the ̀Finder̀ tool.

I define the user interface of the finder tool.
"
Class {
	#name : 'StFinderPresenter',
	#superclass : 'StPresenterWithModel',
	#instVars : [
		'searchBar',
		'resultTree',
		'resultButtonBar',
		'environmentBar',
		'searchOptions',
		'resultStatusBar',
		'previewSourcePresenter',
		'configButton'
	],
	#category : 'NewTools-Finder-Core',
	#package : 'NewTools-Finder',
	#tag : 'Core'
}

{ #category : 'commands' }
StFinderPresenter class >> buildBrowsingOperationsGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'BrowseOperationsMenu') asSpecGroup
		register: ((StFinderBrowseCommand
			forSpecWithIconNamed: StFinderBrowseCommand defaultIconName
			shortcutKey: StFinderBrowseCommand defaultShortcut) context: presenterInstance);
			
		register: ((StFinderReferencesCommand
			forSpecWithIconNamed: StFinderReferencesCommand defaultIconName
			shortcutKey: StFinderReferencesCommand defaultShortcut) context: presenterInstance);
			
		register: ((StFinderSendersCommand
			forSpecWithIconNamed: StFinderSendersCommand defaultIconName
			shortcutKey: StFinderSendersCommand defaultShortcut) context: presenterInstance);
			
		register: ((StFinderImplementorsCommand
			forSpecWithIconNamed: StFinderImplementorsCommand defaultIconName
			shortcutKey: StFinderImplementorsCommand defaultShortcut) context: presenterInstance);
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
StFinderPresenter class >> buildCommandsGroupWith: presenterInstance forRoot: rootCommandGroup [

	rootCommandGroup
		register: (self buildStFinderContextualGroupWith: presenterInstance)
]

{ #category : 'commands' }
StFinderPresenter class >> buildExecutionOperationsGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'ExecutionOperationsMenu') asSpecGroup

		register: ((StFinderDebugItCommand
			forSpecWithIconNamed: StFinderDebugItCommand defaultIconName
			shortcutKey: StFinderDebugItCommand defaultShortcut) context: presenterInstance);

		register: ((StFinderProfileItCommand
			forSpecWithIconNamed: StFinderProfileItCommand defaultIconName
			shortcutKey: StFinderProfileItCommand defaultShortcut) context: presenterInstance);
			
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
StFinderPresenter class >> buildListingOperationsGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'ListingOperationsMenu') asSpecGroup
		register: ((StFinderExpandAllCommand
			forSpecWithIconNamed: #expandBox
			shortcutKey: StFinderExpandAllCommand defaultShortcut) 
				context: presenterInstance);
		register: ((StFinderCollapseAllCommand
			forSpecWithIconNamed: #refresh
			shortcutKey: StFinderCollapseAllCommand defaultShortcut) 
				context: presenterInstance);				
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
StFinderPresenter class >> buildSelectionOperationsGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'SelectionOperationsMenu') asSpecGroup
		register: ((StFinderSelectAllCommand
			forSpecWithIconNamed: StFinderSelectAllCommand defaultIconName
			shortcutKey: StFinderSelectAllCommand defaultShortcut) 
				context: presenterInstance);			
		register: ((StFinderSelectNoneCommand 
			forSpecWithIconNamed: StFinderSelectNoneCommand defaultIconName
			shortcutKey: StFinderSelectNoneCommand defaultShortcut)
				context: presenterInstance);
		register: ((StFinderCopySelectionCommand 
			forSpecWithIconNamed: StFinderCopySelectionCommand defaultIconName
			shortcutKey: StFinderCopySelectionCommand defaultShortcut)
				context: presenterInstance);
		beDisplayedAsGroup;
		yourself
]

{ #category : 'commands' }
StFinderPresenter class >> buildStFinderContextualGroupWith: presenterInstance [

	^ (CmCommandGroup named: 'StFinderSelContextualMenu') asSpecGroup
		register: (self buildExecutionOperationsGroupWith: presenterInstance);	
		register: (self buildBrowsingOperationsGroupWith: presenterInstance);
		register: (self buildListingOperationsGroupWith: presenterInstance);
		register: (self buildSelectionOperationsGroupWith: presenterInstance);
		yourself
]

{ #category : 'default values' }
StFinderPresenter class >> defaultExplanation [

	^ 'The Finder can be used by default in 4 different ways:
	- Selectors: your research is done among selectors
	- Classes : your research is done among classes names
	- Source : your research is done among all the source code
	- Pragmas: your research is done among pragmas
	- Examples : your research uses the Method Finder behavior 
			   (for further informations, print ''FinderUI methodFinderExplanation'')
	
			
In these four modes, you can also tick the ''Use RegEx'' checkbox.
If you pick this box, your search will be done using regular expressions instead of just matching.

The ''Select classes'' button opened a dialog window  to select which classes will be used for the search.
The ''All classes'' button is used to reset the classes selection.'
]

{ #category : 'accessing' }
StFinderPresenter class >> defaultPreferredExtent [

	^ (800 @ 500)
]

{ #category : 'world menu' }
StFinderPresenter class >> menuFinderCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item:  #Finder)
		parent: #Searching ;
		action: [ self open ];
		label: 'Finder';
		order: 2; 
		help: 'Open the Finder tool.';
		iconName: #smallFind.

]

{ #category : 'default values' }
StFinderPresenter class >> methodFinderExplanation [
	"MethodFinder new findMethodsByExampleInput: #( 1 2 ) andExpectedResult: 3."
	"may be this method can be moved to the corresponding search "

	^ 'Use an example to find a method in the system.  
	
   ''a''. ''b''. ''ab''       will find the message #, for strings concatenation
   2. -2                will find the message #negated
   3. 6                 will find the message #factorial
   20. 10. 15. 15       will find the message #min:max:

It works on collections too:

   {2. 4. 5. 1}. 5. 3   will find the message #indexOf:
   {2. 5. 1}. 5. true   will find the message #includes:
	
An example is made up of the following two or more items separated by a period: 
	
	receiver. answer
	receiver. argument1. answer
	receiver. argument1. argument2. answer
	etc...
	
For example, type: 3. 4. 7. into the search box and click <Search>

Take care on separating spaces because of floating point numbers.

 	3.4.7      will find nothing, it is interpreted two numbers, 3.4 and. 7
	3. 4. 7    will find you the message #+
	
The examples array should contain one object for the receiver, one object per expected argument and then a final object with the expected result.	

In other words 
 - a unary method example expects an array of input objects #( receiver ) and an expected result
 - a binary method example expects an array with two input objects #( receiver argument ) and an expected result
 - a keyword method example expects an array with at least two elements  #( receiver argument1 argument2 ... ) and an expected results

The method finder will take the input objects (receiver and arguments) and perform their permutation to be able to find more results.
Then, it will lookup in the receiver''s hierarchy the approved and forbidden methods to run on the hierarchy and run them on the permutation of objects.

Receiver and arguments do not have to be in the right order.

Alternatively, in this bottom pane or in the Playground, use #findMethodsByExampleInput:andExpectedResult: directly to find a method in the system.  Select this line of code and choose "print it" or "inspect it.  

	MethodFinder new findMethodsByExampleInput: #( 1 2 ) andExpectedResult: 3.

It is useful when you want to look for computed objects:
	
	MethodFinder new 
		findMethodsByExampleInput: {''29 Apr 1999'' asDate} 
		andExpectedResult: ''30 Apr 1999'' asDate.

This will find the message #next.

	MethodFinder new 
		findMethodsByExampleInput: {''30 Apr 1999'' asDate} 
		andExpectedResult: ''Friday''. 

This will find the message #dayOfWeekName

The Method Finder is not trying all methods in the system so if it will find nothing, a method with requested behavior may still exist. '

		

]

{ #category : 'instance creation' }
StFinderPresenter class >> newApplication: anApplication model: aModel [

	aModel application: anApplication.
	^ super newApplication: anApplication model: aModel.
]

{ #category : 'opening' }
StFinderPresenter class >> open [
	<script>
	| model presenter |
	
	model := StFinderModel new.
	presenter := self 
		newApplication: StPresenter currentApplication 
		model: model.

	model application: presenter application. 
	presenter open.
	
	^ presenter
]

{ #category : 'opening' }
StFinderPresenter class >> openOnTargets: aCollection [
	"Open the receiver with only search targets (classes) in aCollection. See `availableSearchTargets:` for details"
	
	| finderModel presenter |
	
	finderModel := StFinderModel new
		availableSearchTargetsFromClasses: aCollection;
		yourself.
	presenter := self on: finderModel.
	finderModel application: presenter application. 
	presenter	open.
	^ presenter
]

{ #category : 'instance creation' }
StFinderPresenter class >> openWithText: aText [

	| model presenter |
	model := StFinderModel new.
	presenter := self
		             newApplication: StPresenter currentApplication
		             model: model.
	model application: presenter application.
	presenter open.
	
	presenter searchBar searchInput text: aText.
	^ presenter
]

{ #category : 'searching' }
StFinderPresenter class >> searchBy: aString [ 
	self shouldBeImplemented.
]

{ #category : 'updating - widgets' }
StFinderPresenter >> cleanResults [

	resultTree roots: Array empty
]

{ #category : 'initialization' }
StFinderPresenter >> connectPresenters [

	self connectSearchBar.

	configButton action: [
		SettingBrowser new
			rootNodes: (SettingBrowser currentTree nodeNamed: #finder) allChildren;
			open ].

	self connectSearchOptions.
	searchOptions substringBox click.

	environmentBar
		whenAllPackagesSelectedDo: [ self searchInAllPackages ];
		whenPackagesSelectedDo: [ self openPackageChooserDialog ].

	resultTree 
		whenSelectedItemChangedDo: [ :newResult |
			newResult 
				ifNil: [ self resultButtonBar disableAll ] 
				ifNotNil: [
					newResult forFinderPreview: previewSourcePresenter.
					self resultButtonBar enableButtonsFor: newResult ] ].

	self connectResultButtons.
	self subscribeToAnnouncements
]

{ #category : 'initialization' }
StFinderPresenter >> connectResultButtons [

	resultButtonBar browseAction: [ self selectedResult ifNotNil: [ :result | result browseAction ] ].
	resultButtonBar sendersAction: [ self selectedResult ifNotNil: [ :result | result sendersAction ] ].
	resultButtonBar implementersAction: [ self selectedResult ifNotNil: [ :result | result implementersAction ] ].
	resultButtonBar versionsAction: [ self selectedResult ifNotNil: [ :result | result versionsAction ] ].
	resultButtonBar inheritanceAction: [ self selectedResult ifNotNil: [ :result | result inheritanceAction ] ].
	resultButtonBar hierarchyAction: [ self selectedResult ifNotNil: [ :result | result hierarchyAction ] ]
]

{ #category : 'initialization' }
StFinderPresenter >> connectSearchBar [

	searchBar
		whenSubmitSearchDo: [ :text | self model searchBy: text ];
		whenSearchModeChangedDo: [ :new | self model currentSearch: new ]
]

{ #category : 'initialization' }
StFinderPresenter >> connectSearchOptions [

	searchOptions
		whenSubstringActivatedDo: [ 
			self model useSubstring: true.
			searchOptions 
				disableExact;
				disableRegex ];
		whenSubstringDeactivatedDo: [ 
			self model useSubstring: false.
			searchOptions
				enableExact;
				enableRegex ];

		whenRegexActivatedDo: [ 
			self model useRegex: true.
			searchOptions 
				disableSubstring;
				disableExact. ];
		whenRegexDeactivatedDo: [ 
			self model useRegex: false.
			searchOptions 
				enableSubstring;
				enableExact ];
		
		whenCaseActivatedDo: [ self model useCase: true ];
		whenCaseDeactivatedDo: [ self model useCase: false ];
		
		whenExactActivatedDo: [
			self model useExact: true.
			searchOptions 
				disableSubstring;
				disableRegex ];
		whenExactDeactivatedDo: [ 
			self model useExact: false.
			searchOptions 
				enableSubstring;
				enableRegex ].
]

{ #category : 'layout' }
StFinderPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 2;
				   add: searchBar;
				   addLast: configButton;
				   yourself)
		  expand: false;
			add: (SpBoxLayout newLeftToRight
				   add: searchOptions;
				   add: environmentBar;
				   yourself)
			expand: false;
			add: resultTree;
			add: resultButtonBar expand: false;		
			add: previewSourcePresenter;
			addLast: resultStatusBar expand: false;
		  yourself
]

{ #category : 'initialization' }
StFinderPresenter >> initializeFocus [

	self focusOrder 
		add: searchBar;
		add: resultTree;
		add: environmentBar;
		add: previewSourcePresenter.
]

{ #category : 'initialization' }
StFinderPresenter >> initializePresenters [

	searchBar := self instantiate: StFinderSearchBar.
	searchBar searchModes: self model availableSearchTargets.

	configButton := self newButton
		              icon: (self iconNamed: #config);
		              yourself.

	searchOptions := self instantiate: StFinderSearchOptions.

	environmentBar := self instantiate: StFinderEnvironmentBar.
	self updateEnvironmentStatusFor: self model selectedPackages.

	self initializeResultTree.
		
	previewSourcePresenter := self newCode.

	resultButtonBar := self instantiate: StFinderResultButtonBar.

	resultStatusBar := self newStatusBar.
	self initializeFocus.
]

{ #category : 'initialization' }
StFinderPresenter >> initializeResultTree [

	resultTree := self newTree
		beMultipleSelection;
		display: [ :result | result displayString ];
		displayIcon: [ :result | result displayIcon ];
		children: [ :result | result children ];
		addShortcutWith: [ :action | action 
			shortcutKey: $b actionModifier;
			action: [ self resultTree selectedItem browseAction ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: $r actionModifier;
			action: [ self resultTree selectedItem referencesAction ] ];
		actions: self rootCommandsGroup / 'StFinderSelContextualMenu';
		yourself
]

{ #category : 'updating - widgets' }
StFinderPresenter >> notifySearchStarted [
	"Do nothing for now"


]

{ #category : 'private' }
StFinderPresenter >> openPackageChooserDialog [
	"Opens a `SpChooserPresenter` dialog to allow the user to choose the packages to search in."

	((SpChooserPresenter
		  sourceItems: self model unselectedPackages
		  chosenItems: self model selectedPackages)
		 sourceLabel: 'Available packages';
		 targetLabel: 'Selected packages';
		 openDialog)
		title: 'Select packages for searching';
		okAction: [ :dialog | self searchInPackages: dialog presenter chosenItems ]
]

{ #category : 'accessing' }
StFinderPresenter >> resultButtonBar [

	^ resultButtonBar
]

{ #category : 'accessing' }
StFinderPresenter >> resultTree [

	^ resultTree
]

{ #category : 'accessing' }
StFinderPresenter >> searchBar [

	^ searchBar
]

{ #category : 'searching' }
StFinderPresenter >> searchBy: aString [ 

	^ self announcingObject searchBy: aString
]

{ #category : 'private' }
StFinderPresenter >> searchInAllPackages [
	"Selects all packages for searching."

	self model selectAllPackages.
	environmentBar activateAllPackages.
	self updateEnvironmentStatusFor: self model selectedPackages
]

{ #category : 'private' }
StFinderPresenter >> searchInPackages: aCollection [
	"Sets the search environment in the model to the package names given in aCollection."

	self model selectedPackagesByName: aCollection.
	environmentBar activateChosenPackages.
	self updateEnvironmentStatusFor: aCollection
]

{ #category : 'accessing' }
StFinderPresenter >> searchMode [
	"Answer a <StFinderSearch> with the currently selected search mode"

	^ searchBar searchMode
]

{ #category : 'initialization' }
StFinderPresenter >> searchOptions [
	"Answer the receiver's <StFinderSearchOptions>"

	^ searchOptions
]

{ #category : 'accessing' }
StFinderPresenter >> searchText [
	"Answer a <String> with the currently typed text in the search bar"
	
	^ self searchBar searchText
]

{ #category : 'information' }
StFinderPresenter >> selectedResult [

	^ resultTree selectedItem
]

{ #category : 'accessing - properties' }
StFinderPresenter >> selectedResults [
	"Answer the receiver's <Collection> of selected results"

	^ self application 
		propertyAt: #selectedResults
		ifAbsentPut: [ Set new ]
]

{ #category : 'accessing - properties' }
StFinderPresenter >> selectedResults: aCollection [ 
	"Set a <Collection> of results to be marked for future operations"

	^ self application 
		propertyAt: #selectedResults
		put: aCollection asSet
]

{ #category : 'initialization' }
StFinderPresenter >> subscribeToAnnouncements [

	self model whenSearchStarted: [ self notifySearchStarted ].
	self model whenSearchEnded: [ :results : time | self updateResultsWith: results time: time ].
	self model whenSearchTypesChanged: [ self searchBar updateSearchModes ]
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateEnvironmentStatusFor: packages [

	environmentBar status: packages size asString , ' Packages selected'
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updatePreview: aStFinderSearch [ 

	self flag: #toDo.
	previewSourcePresenter ifNotNil: [ : p | 
		self searchMode updateDefaultPreview: p ].
	"| newPresenter presenterToReplace |

	newPresenter := self instantiate: aStFinderSearch previewPresenter.
	newPresenter text: aStFinderSearch previewText.
	presenterToReplace := self layout subpresenterOrLayoutNamed: #previewSourcePresenter of: self.
	self layout 
		replaceAtIndex: 3 
		with: newPresenter"
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateResultsBehavior [
	"Private - Callback to control events after a new search has finished"
	
	StFinderSettings expandResults
		ifTrue: [ resultTree expandAll ].

	resultTree roots 
		ifNotEmpty: [ : items | self updateResultsSelection: items ]
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateResultsSelection: aCollection [
	"Private - aCollection represents the found items. 
	Search and select an exact match between the search text in aCollection, if possible. If not found then select the first item.
	For expansion use the current settings"
	
	| itemToSelect |
	itemToSelect := aCollection
		                detect: [ :item | item matches: self searchText ]
		                ifFound: [ :item | item ]
		                ifNone: [ aCollection first ].
	resultTree selectItem: itemToSelect.
	itemToSelect hasChildren 
		ifFalse: [ ^ self ].
	itemToSelect selectItemIn: resultTree.
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateResultsWith: results time: time [
	"Call to update resultTree with results."

	resultTree
		roots: results.
	self updateResultsBehavior.
	resultStatusBar pushMessage: (self updateStatusBarTextFrom: results time: time).
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateSearchOptions: aCollection [ 
	"Private - Update the receiver's search options using aCollection which contains the selectors to enable"
	
	searchOptions
		ifNotNil: [ aCollection do: [ : selector | searchOptions perform: selector ] ]
]

{ #category : 'updating - widgets' }
StFinderPresenter >> updateStatusBarTextFrom: results time: time [

	^ String streamContents: [ : stream |
		stream
			<< 'Search of ';
			<< searchBar searchModeName;
			<< ' for ';
			<< searchBar searchText surroundedBySingleQuotes;
			<< ' found ';
			<< results size asString;
			<< ' results and took ';
			<< time asStringWithCommas;
			<< ' ms' ]
]

{ #category : 'initialization' }
StFinderPresenter >> windowIcon [

	^ self iconNamed: #smallFind

]

{ #category : 'initialization' }
StFinderPresenter >> windowTitle [

	^ 'Finder'

]
