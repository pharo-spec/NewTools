"
I check that the Critic Browser (`StCritiqueBrowserPresenter`) follows the changes of the code it shows, in particular the change of an ""Automatically resolve the issue"".

## Responsibility:

- Check that a fixed method leaves the list of critiques, and that the source pane shows its new version or its remaining critique.
- Check that the selection on another method is kept and that selecting the rule stops following a fixed method.
- Check that the browser listens to code changes only while its window is open, and that a fix does not count as a manifest change.

## Collaborators:

- `StCritiqueBrowserPresenter`: opened on `ReEqualNilRule` and on a fixture package; `runRules` checks the package in the current process.
- `ReChangeManager`: applies the change of a critique, as the changes browser does when the user accepts it.
- `ShiftClassInstaller`: creates the fixture class `StCritiqueBrowserAfterChangeFixture`, removed with its package in `tearDown`.

## Public API and Key Messages

- `selectAndApplyCritiqueOn: aSelector` selects the first critique on a fixture method and applies its change.
- `critiquesOn: aSelector` answers the listed critiques on a fixture method.

For example:

```
self selectAndApplyCritiqueOn: #foo:.
self assert: (self critiquesOn: #foo:) isEmpty
```

## Internal Representation

- `browser`: the opened `StCritiqueBrowserPresenter`.
- `fixtureClass`: a class whose methods `foo:`, `bar:` and `both:and:` compare to nil.

### Implementation Points

- `tearDown` marks the cache as unchanged before closing, so that no modal question about the manifests blocks the tests.
"
Class {
	#name : 'StCritiqueBrowserPresenterAfterChangeTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser',
		'fixtureClass'
	],
	#category : 'NewTools-CodeCritiques-Tests',
	#package : 'NewTools-CodeCritiques-Tests'
}

{ #category : 'helpers' }
StCritiqueBrowserPresenterAfterChangeTest >> apply: aCritique [
	"Apply the change of aCritique, as the changes browser does when the user accepts it."

	ReChangeManager instance performChanges: { aCritique change }
]

{ #category : 'helpers' }
StCritiqueBrowserPresenterAfterChangeTest >> critiquesOn: aSelector [
	"Answer the critiques listed by the browser about the method aSelector of the fixture class."

	^ browser critiquesModel items select: [ :each | each sourceAnchor entity selector = aSelector ]
]

{ #category : 'helpers' }
StCritiqueBrowserPresenterAfterChangeTest >> fixturePackageName [

	^ 'NewTools-CodeCritiques-Tests-Fixture'
]

{ #category : 'helpers' }
StCritiqueBrowserPresenterAfterChangeTest >> selectAndApplyCritiqueOn: aSelector [

	| critique |
	critique := (self critiquesOn: aSelector) first.
	browser critiquesModel selectItem: critique.
	self apply: critique
]

{ #category : 'running' }
StCritiqueBrowserPresenterAfterChangeTest >> setUp [

	super setUp.
	fixtureClass := ShiftClassInstaller make: [ :builder |
		builder
			name: #StCritiqueBrowserAfterChangeFixture;
			superclass: Object;
			package: self fixturePackageName ].
	fixtureClass compile: 'foo: x
	^ x = nil' classified: #fixture.
	fixtureClass compile: 'bar: x
	^ x = nil' classified: #fixture.
	fixtureClass compile: 'both: x and: y
	^ (x = nil) -> (y = nil)' classified: #fixture.
	browser := StCritiqueBrowserPresenter new
		rules: { ReEqualNilRule new };
		environment: (RBPackageEnvironment packageName: self fixturePackageName);
		removeTestCase: false;
		yourself.
	browser open.
	browser runRules.
	browser rulesModel selectPath: #( 1 1 )
]

{ #category : 'running' }
StCritiqueBrowserPresenterAfterChangeTest >> tearDown [

	"no question about the manifests when the browser closes"
	browser cache cacheNotChanged.
	browser window ifNotNil: [ :window | window close ].
	fixtureClass removeFromSystem.
	(PackageOrganizer default packageNamed: self fixturePackageName ifAbsent: [ nil ]) ifNotNil: [ :package | package removeFromSystem ].
	super tearDown
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testClosedBrowserNoLongerFollowsCodeChanges [

	browser window close.

	self deny: (browser class codeChangeAnnouncer hasSubscriber: browser)
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testFixDoesNotChangeTheManifests [

	self selectAndApplyCritiqueOn: #foo:.

	self deny: browser cache cacheChange
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testFixedMethodLeavesTheList [

	self selectAndApplyCritiqueOn: #foo:.

	self assert: (self critiquesOn: #foo:) isEmpty.
	self assert: (self critiquesOn: #bar:) size equals: 1
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testMarkingWrongChangesTheManifests [

	| critique |
	critique := (self critiquesOn: #foo:) first.

	browser cache addFalsePositive: critique forRule: critique rule.

	[ self assert: browser cache cacheChange ] ensure: [ browser cache cacheNotChanged ]
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testOpenedBrowserFollowsCodeChanges [

	self assert: (browser class codeChangeAnnouncer hasSubscriber: browser)
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testPaneShowsNewVersionOfFixedMethod [

	self selectAndApplyCritiqueOn: #foo:.

	self assert: browser sourceCodeModel text asString equals: (fixtureClass >> #foo:) sourceCode
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testRemainingCritiqueOfFixedMethodIsSelected [

	self selectAndApplyCritiqueOn: #both:and:.

	self assert: browser critiquesModel selectedItem sourceAnchor entity identicalTo: fixtureClass >> #both:and:
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testSelectingTheRuleStopsFollowingTheFixedMethod [

	self selectAndApplyCritiqueOn: #foo:.
	browser rulesModel unselectAll.
	browser rulesModel selectPath: #( 1 1 ).

	fixtureClass compile: 'foo: x
	^ x' classified: #fixture.

	self assert: browser sourceCodeModel text asString equals: ReEqualNilRule new rationale
]

{ #category : 'tests' }
StCritiqueBrowserPresenterAfterChangeTest >> testSelectionOnAnotherMethodIsKept [

	| selected |
	selected := (self critiquesOn: #both:and:) last.
	browser critiquesModel selectItem: selected.

	self apply: (self critiquesOn: #foo:) first.

	self assert: browser critiquesModel selectedItem identicalTo: selected
]
