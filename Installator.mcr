/*
	Simple installator
	by MastaMan
	https://3dground.net/
*/

global currentScript = "3DH Model Fixer.ms"
global currentScriptMacro = "THREEDH_MF"
global currentScriptCat = "[3DGROUND]"

global currentPath = getFilenamePath (getThisScriptFilename())
global currentScriptName = (getFilenameFile currentScript)
global toExecute = "macroScript " + currentScriptMacro + "
Buttontext: \"" + currentScriptName + "\"
category:\"" + currentScriptCat + "\"
toolTip:\"" + currentScriptName + "\"
Icon:#(\"UVWUnwrapView\", 15)
(
	on execute do
	(
		szScript =  @\"" + currentPath + currentScript + "\"
		try(fileIn(szScript)) catch(messageBox \"Script not found! Download " + currentScriptName + " again!\" title: \"Warning!\")
	)
)"
	
execute toExecute

fn addQuadMenuButton macro cat txt remove: false =
(
	quadMenu = menuMan.getViewportRightClickMenu #nonePressed
	theMenu = quadMenu.getMenu 1

	fn findMenuItem theMenu menuName =
	(
		for i in 1 to theMenu.numItems() where (theMenu.getItem i).getTitle() == menuName do return i
		return 0
	)

	fn unregisterMenuItem theMenu menuName =
	(	
		try
		(
			for i in 1 to theMenu.numItems() do
			(
				if((theMenu.getItem i).getTitle() == menuName) do
				(
					theMenu.removeItemByPosition i 						
					if((theMenu.getItem (i - 1)).getIsSeparator()) do theMenu.removeItemByPosition (i - 1)
				)
			)
		)catch()
	)

	item = try(findMenuItem theMenu "Select &Similar")catch(6)

	unregisterMenuItem theMenu txt
	
	if(not remove) do
	(
		quadItem = menuMan.createActionItem macro (cat)
		
		theMenu.addItem quadItem (item += 1)
	)
		
	menuMan.updateMenuBar()
)

addQuadMenuButton currentScriptMacro currentScriptCat currentScriptName remove: true
addQuadMenuButton currentScriptMacro currentScriptCat currentScriptName remove: false

szScript =  currentPath + currentScript
try(fileIn(szScript)) catch()