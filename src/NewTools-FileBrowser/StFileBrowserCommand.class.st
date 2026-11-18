"
I am the root of the commands of the context menus of the file dialogs: new folder, rename, remove, copy name, compress, bookmarks, …

## Life cycle: who creates the commands and who uses them

1. **Presenters register them in their context menu** with `forSpec`, in `buildCommandsGroupWith:forRoot:`: `StFileNavigationSystemPresenter` for the file table ('StFileBrowserNavigationMenu'), `StDirectoryTreePresenter` for the directory tree ('StFileBrowserDirectoryContextualMenu') and `StFileSystemPresenter` for the bookmarks ('StFileBrowserBookmarksMenu').
2. **The presenter of the menu is the context.** A command asks it for the selection or the current directory (`selectedEntry`, `currentDirectory`) and, after a change, to refresh the dialog (`updateFileSystemPresenters`).
3. **`asSpecCommand`** gives each command its icon and, for most, a shortcut key.

## Responsibility:

- Give my commands their application (`application`) and icon provider (`StFileBrowserIconCache`).

## Collaborators:

- `CmCommand`: my superclass.
- `StFileNavigationSystemPresenter`, `StDirectoryTreePresenter`, `StFileSystemPresenter`: register my subclasses and are their context.

## Examples

```smalltalk
StFileBrowserCommand scriptFileTableMenu.
```

It inspects the commands of the file table menu with their shortcut keys.
"
Class {
	#name : 'StFileBrowserCommand',
	#superclass : 'CmCommand',
	#category : 'NewTools-FileBrowser-Commands',
	#package : 'NewTools-FileBrowser',
	#tag : 'Commands'
}

{ #category : 'script' }
StFileBrowserCommand class >> scriptFileTableMenu [
	"Inspects the commands of the context menu of the file table of the file dialogs, with their shortcut keys, as StFileNavigationSystemPresenter registers them."

	<example>
	| root |
	root := (CmCommandGroup named: 'root') asSpecGroup.
	StFileNavigationSystemPresenter buildCommandsGroupWith: nil forRoot: root.
	^ ((root / 'StFileBrowserNavigationMenu') allCommands collect: [ :command |
		   command name -> (command hasShortcutKey ifTrue: [ command shortcutKey ]) ]) inspect
]

{ #category : 'executing' }
StFileBrowserCommand >> application [

	^ self context application
]

{ #category : 'accessing' }
StFileBrowserCommand >> iconProvider [ 

	^ StFileBrowserIconCache 
]
