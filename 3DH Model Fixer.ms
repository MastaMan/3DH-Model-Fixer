/*  
[INFO] 
NAME = 3DH Model Fixer
VERSION = 1.0.0
AUTHOR = MastaMan
DEV = https://3dground.net
HELP = 
CLIENT=Klisch Danylo
[ABOUT]
Script for prepare and QA models for 3DH =

[1.0.0]
* Initial release =

[SCRIPT]
*/

/*************************************************/
-- VARIABLES
/*************************************************/


try(cui.UnRegisterDialogBar floater3dhModeFixer) catch()
try(closeRolloutFloater floater3dhModeFixer)catch()
try(closeRolloutFloater floaterShotGunTools) catch()
global floater3dhModeFixer = newRolloutFloater "3DH Model Fixer" 300 720


rollout _rAbout3DH "About" (
    label lblName "" 
    label lblVer "" 
    
    label lblAuthor "" height: 30
    hyperlink lblCopy ""  align: #center
	timer tmrRestart "" active: false interval: 300
    
	fn downloadFile url dl = (
		deleteFile dl
		w = dotNetObject "System.Net.WebClient"			
		try(
			spm = dotNetClass "System.Net.ServicePointManager"
			spm.SecurityProtocol = spm.SecurityProtocol.TLS12				
			w.DownloadFile (url + "?time=" + timestamp() as string) dl				
		) catch(
			return false
		)
		
		return true
	)
	
	fn bgUpdate = (
		url = "https://raw.githubusercontent.com/MastaArt/shot-grid-tools/main/ShotGrid%20Tools.ms"
		this = getThisScriptFileName()
		dl = this + ".tmp"
		r = downloadFile url dl
		if(not r or not doesFileExist dl) do return print "Can't download updates!"
		vn = getIniSetting dl "INFO" "VERSION"
		vo = getIniSetting this "INFO" "VERSION"
		
		if(vn > vo) do (
			deleteFile this
			renameFile dl this
			
			tmrRestart.active = true
		)
		
		deleteFile dl
	)
	
	fn updateWorker = (
		m = dotnetobject "CSharpUtilities.SynchronizingBackgroundWorker"
		m.WorkerSupportsCancellation = true 
		m.CancelAsync() 
		dotNet.addEventHandler m "DoWork" bgUpdate
		m.RunWorkerAsync()	
	)
	
    fn getScriptInfo s releaseInfo: "" =  (
        if(releaseInfo != "") do (
            r = getINISetting s releaseInfo
            return r
        )

        v = getINISetting s "INFO" "VERSION"
        a = getINISetting s "INFO" "AUTHOR"
        n = getINISetting s "INFO" "NAME"
        o = getINISetting s "ABOUT"
        c = getINISetting s "INFO" "DEV"
        h = getINISetting s "INFO" "HELP"
        
        r = for i in (getINISetting s) where (i != "ABOUT" and i != "SCRIPT" and i != "COPY") collect i
        
        return #(n, a, v, o, r, c, h)
    )
	
	on tmrRestart tick do (
		this = getThisScriptFileName()
		try(fileIn this) catch()
		vo = getIniSetting this "INFO" "VERSION"
		m = ("Script updated to version " + vo + "!\n\n\n")
		for c in (getIniSetting this vo) do (
			m += c + "\n"
		)
		
		messageBox m title: "Success!" beep: false
		tmrRestart.active = false
	)

    on _rAbout3DH open do (
        i = getScriptInfo (getThisScriptFilename())
   
        lblName.caption = i[1]
        lblAuthor.caption = i[2]
        lblVer.caption = i[3]
        lblCopy.address  = lblCopy.caption = i[6]
			
		try (floaterShotGunTools.title = i[1] + " " +  i[3]) catch()
			
		updateWorker()
    )
	
	on _rAbout3DH rolledUp x do sliderStep 2 x
)


addRollout _rAboutSGT floater3dhModeFixer rolledUp: true 