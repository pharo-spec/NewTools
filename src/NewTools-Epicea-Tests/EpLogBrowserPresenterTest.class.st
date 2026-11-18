"
I test `EpLogBrowserPresenter`, the browser of an Epicea log, at the presenter level, without opening it; it is created on the default log.

## Responsibility:

- Check that the filters menu (`filtersSubMenu`), opened by the toolbar of the browser, is created through the browser, so that it belongs to it and uses its application.
- Check the content of that menu: its five groups, the first one offering to clean the active filters.

## Collaborators: 

- `EpLogBrowserPresenter`: the presenter under test.
- `EpLogBrowserToolbarPresenter>>beHistoryMode`: the user of the filters menu.

## Internal Representation

- `browser`: the presenter under test.
"
Class {
	#name : 'EpLogBrowserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser'
	],
	#category : 'NewTools-Epicea-Tests',
	#package : 'NewTools-Epicea-Tests'
}

{ #category : 'running' }
EpLogBrowserPresenterTest >> setUp [

	super setUp.
	browser := EpLogBrowserPresenter new
]

{ #category : 'tests' }
EpLogBrowserPresenterTest >> testFiltersMenuIsOwnedByTheBrowser [

	self assert: browser filtersSubMenu owner identicalTo: browser
]

{ #category : 'tests' }
EpLogBrowserPresenterTest >> testFiltersMenuOffersToCleanTheActiveFilters [

	| menu |
	menu := browser filtersSubMenu.
	self assert: menu menuGroups size equals: 5.
	self assert: menu menuGroups first menuItems first name equals: 'Clean filters (0 active)'
]
