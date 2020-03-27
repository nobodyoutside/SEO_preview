-- 프리뷰 1.1.2 gif-maker가 없을 경우 비활성화
-- 1.1.3 랜더 사이즈 오류 수정중
-- 2019-07-07 : attribute 활용
weaponDataCA = attributes weaponData (
	parameters main rollout:params (
		hitPoints type:#float ui:hits default:10
		cost type:#float ui:cost default:100
		sound type:#string
	)
	rollout params "Weapon Parameters" (
		spinner hits "Hit Points" type:#float
		spinner cost "Cost" type:#float
		dropdownlist sound_dd "Sound" items:#("boom", "sparkle", "zap", "fizzle")

		on sound_dd selected i do sound = sound_dd.items[i]
	)
)
-- rootnode에 weaponDataCA 를 추가
CustAttributes.add rootnode weaponDataCA
-- rootscene weaponDataCA 를 추가
CustAttributes.add rootscene weaponDataCA

macroScript PreviewTool
category:"_AniSeoHyun"
ToolTip:"PreviewTool"
icon: #("Render", 2)
(
    global previewRollout, gifRollout
    global filterKey = "@"
    global maxfileNameAdd = ""
    global gifpath

    local displayColor_setting = #material
    local dspBones_setting = false
    local ambientColor_stting = ambientColor
    local lightLevel_stting = lightLevel


    help = "기본 해상도 :1280*720, '필터와' '파일명 주속 달기'는 입력후 엔터 필수!"

      if previewRollout != undefined do
    (
        DestroyDialog previewRollout
    )  

    fn getValFileList_fn val_filter val_dir =
    (
        local fileName = ""
        local fileName = "\\"+ val_filter as string
        local maxlist = #()
        local dir = val_dir

        maxfileName_arr =#()

        print val2

        if dir == undefind do 
        (
            cnacelTag = true
        )
        maxlist = getFiles (dir + fileName)
        format "\nmaxlist\n % "maxlist

        if maxlist.count == 0 and cnacelTag == false then messagebox "맥스파일이 없습니다."
        else 
        (
            maxlist
        )
        return maxlist
    )

    rollout previewRollout "Preview"
    (
        local getDirPath = undefined
        local fileNameFile_arr = #()
        local maxfileName_arr = #()

        local viewport_tag = #view_none
        local selectedLevel = #smoothhighlights
        local percentSize_setting = 100 as integer
        local fps_setting = 30 as integer
        local dspGrid_setting = false
        local CameraChack = false 

        fn setAutoPlayPreview state enabled:off = 
        (
            state = if state then 1 else 0
            local prev 
            fn PreferenceCallback &state:&state &prev:&prev = 
            (
                fn getCheckBoxState hwnd = 
                (	
                    local BM_GETCHECK = 240
                    windows.sendMessage hwnd BM_GETCHECK 0 0
                )
                fn setCheckBoxState hwnd act = 
                (
                    local BN_CLICKED = 0
                    local BM_SETCHECK = 241
                    local WM_COMMAND = 273

                    local parent = UIAccessor.getParentWindow hwnd
                    local id = UIAccessor.getWindowResourceID hwnd

                    windows.sendMessage hwnd BM_SETCHECK act 0
                    windows.sendMessage parent WM_COMMAND ((bit.shift BN_CLICKED 16) + id) hwnd	
                    act
                )
                hWND = DialogMonitorOPS.GetWindowHandle()

                if (UIAccessor.GetWindowText hWND) == "Preference Settings" do 
                (
                    if (bt = windows.getchildhwnd hWND "AutoPlay Preview File") != undefined do
                    (
                        if (prev = getCheckBoxState bt[1]) != state do state = setCheckBoxState bt[1] state
                    )
                    UIAccessor.SendMessageID hWND #IDOK
                )
                true
            )

            DialogMonitorOPS.RegisterNotification PreferenceCallback id:#preferencesConfigure
            DialogMonitorOPS.Enabled = true	
            max file preferences
            DialogMonitorOPS.unRegisterNotification id:#preferencesConfigure
            DialogMonitorOPS.Enabled = enabled
            prev == 1 
        )


        fn seletedView_fn val =
        (
            case val of
            (
                1: viewport_tag = #view_none
                    
                2: viewport_tag = #view_camera

                3: viewport_tag = #view_persp_user

                default : viewport_tag = #view_none
            )	
            format "\n viewport_tag = % \n" viewport_tag
        )

        fn PreviewExport_fn =
        ( --1.3.3 버전용
            renderWidth = 1280 as integer
            renderHeight = 720 as integer

            actionMan.executeAction 0 "618"
            displayColor.shaded = displayColor_setting
            if (displayColor_setting == #object ) do
            (
                ambientColor = color 0 0 0
                lightLevel = 1.0
            )

            createPreview percentSize:percentSize_setting fps:fps_setting dspBones:dspBones_setting rndLevel:#smoothhighlights 

            MaxDefaultPreviewFile = ((getdir #preview) + "\\_scene.avi" )
            TargetFolder = maxfilepath
            TargetPreviewFileName = ((getFilenameFile maxfileName) + maxfileNameAdd + ".avi")
            deleteFile (TargetFolder + TargetPreviewFileName)
            copyFile MaxDefaultPreviewFile (TargetFolder + TargetPreviewFileName)
        )
        
         group "Satting"
        (
            checkbox dspBones_checkbox "Hide Bone" offset:[0,5]
            spinner	percentSize_spinner "Preview Size(1280*720)" range:[0, 100, 100] type:#integer scale:1 fieldWidth:32 offset:[-15,-22.5] tooltip:"기본 1280*720입니다."
            label percent_label "%" offset:[130,-20]
            checkbox displayColor_checkbox "Object Color" offset:[0,5]

            edittext filterName_text "필터 :" fieldWidth:25 offset:[0,15]
            edittext maxfileNameAdd_text "파일명 주석 달기 :" fieldWidth:120 offset:[0,-22.5] align:#right
            label help_label "<< 입력후 엔터 필수 >>" offset:[0,0] align:#center

            on filterName_text entered filterKey do
            (
            global filterKey = filterName_text.text
            ) 

            on maxfileNameAdd_text entered maxfileNameAdd do
            (
            global maxfileNameAdd = maxfileNameAdd_text.text
            ) 

            on dspBones_checkbox changed state do
            (
                if (dspBones_checkbox.state == true) then 
                (
                    hideByCategory.bones = true
                    dspBones_setting = false
                )
                else
                (
                    hideByCategory.bones = false
                    dspBones_setting = true
                )
            )

            on displayColor_checkbox changed state do
            (
                if (displayColor_checkbox.state == true) then 
                (
                    displayColor.shaded = #object
                    displayColor_setting = #object
                    ambientColor = color 0 0 0
                    lightLevel = 1.0
                )
                else
                (
                    displayColor.shaded = #material
                    displayColor_setting = #material
                    ambientColor = ambientColor_stting
                    lightLevel = lightLevel_stting
                )
            )
            on percentSize_spinner changed state do
            (
                percentSize_setting = percentSize_spinner.range[3] as integer
            )

        ) 
         group "Export run"
        (
            button exportMaxFile_btn "파일 경로 열기" width:80 offset:[-85, 0] tooltip:"현 맥스파일의 폴더를 열어줍니다."
            button previewFolderExport_btn "Folder 만들기" width:80 offset:[0, -26.5] tooltip:"해당 폴더에서 필터의 글자가 있는 맥스파일만 프리뷰를 만듭니다."
            button previewFileExport_btn "File 만들기" width:80 offset:[85, -26.5] tooltip:"맥스파일명으로 프리뷰를 생성합니다. 파일에 추가적 설명을 넣기위해서는 '파일명 주석 달기'를 이용해주세요."
            button gif_btn "Gif실행" width:80 offset:[0,0] tooltip:"Gif-maker가 설치되어 있어야됩니다."

            on exportMaxFile_btn pressed do
            (
                ShellLaunch maxfilepath ""
            )

            on previewFileExport_btn pressed do
            (
                local previewNow = ""
                PreviewExport_fn()
                previewNow = (maxfilepath +(getFilenameFile maxfileName) + maxfileNameAdd + ".avi")
                ShellLaunch previewNow ""

            )

            on previewFolderExport_btn pressed do
            (
                try (getDirPath = getSavePath caption:"소스 MAX파일 폴더 선택"() ) catch ( getDirPath = "")
                fileNameVal_str = "*"+ filterKey +"*.max"
                try (previewMaxlist = getValFileList_fn fileNameVal_str getDirPath) catch (previewMaxlist = #() )
                if previewMaxlist.count > 0 then
                (
                    for i in 1 to previewMaxlist.count do
                    (
                        loadmaxfile previewMaxlist[i] useFileUnits:true quiet:on 
                        completeredraw()
                        PreviewExport_fn()
                    )
                )
                else
                (
                    messagebox "맥스파일이 없습니다."
                )
            )

            on gif_btn pressed do
            ( 
                createdialog gifRollout
            )
        ) 
        on previewRollout open do 
        ( --Update
            print selectedLevel
            print viewport_tag
            filterName_text.text = filterKey

            displayColor_setting = displayColor.shaded
            if (displayColor_setting == #object) do displayColor_checkbox.state = true
            hideByCategory.bones = true
            dspBones_checkbox.state = hideByCategory.bones
            if (displaySafeFrames == false) do 	max safeframe toggle
            ambientColor_stting = ambientColor
            lightLevel_stting = lightLevel
        )  
    ) 

    --Gif Maker스크립트를 들고옴
     rollout gifRollout "Gif maker v4 make by 안태희, seo수정" width:308 height:187
    (
        label filename_label "" pos:[150,15] align:#center
        edittext 'edt1' "" pos:[19,36] width:193 height:20 align:#left
        button 'btn1' "Path" pos:[212,35] width:57 height:23 align:#left
        label 'lbl1' "용량:" pos:[216,92] width:84 height:14 align:#left
        label 'lbl5' "사이즈:40%" pos:[94,63] width:127 height:19 align:#left
        slider 'sld1' "" pos:[36,84] width:178 height:25 range:[10,100,40] align:#left

        button 'btn9' "File Go" offset:[15,10] width:111 height:37 align:#left
        button folderGifmaker "Folder Go" offset:[-15,-42.5] width:111 height:37 align:#right

        fn makegif =
        (
            local percent = ""

             fn deleteFolder folderPath: =
            (
                local sioDir = dotNetClass "System.IO.Directory"
                if (SIODir.Exists folderPath) do SIODir.Delete (folderPath) true
            ) 
            st = timestamp()
            vp = getViewSize()
            renderWidth = vp[1];renderheight = vp[2];completeRedraw();

            if (dspBones_setting  == false ) then
            (
                hideByCategory.bones = true
            )
            else
            (
                hideByCategory.bones = false
            )

            if (displayColor_setting == #object ) do
            (
                displayColor.shaded = #object
                ambientColor = color 0 0 0
                lightLevel = 1.0
            )

            deleteFolder folderPath:"c:\\GIFtemp"
            makeDir ("c:\\GIFtemp\\") all:true
            outFile = "c:\\GIFtemp\\temp"
            exepath = "nconvert.exe"
            exepath2 ="gifsicle.exe"
            percent =(sld1.value as integer)as string

            Yp = ((vp[2]*sld1.value/100.0) as integer)as string
            Xp = ((vp[1]*sld1.value/100.0)as integer)as string

            ratio = vp[2]/vp[1]
            local size=vp[2]
            w=(size*ratio)as integer

            startk = (animationrange.start as integer/1f as integer)
            for t = animationrange.start to animationrange.end by 1f do
            (
                slidertime = t
                x = (t as integer/1f as integer)
                xx = formattedPrint (x-startk) format:"0.5d"
                img = Bitmap vp[1] vp[2] filename:(outFile+(xx+".bmp"))
                copy (gw.getViewportDib()) img
                save img
            )

            hiddenDOSCommand (exepath+" -out gif -resize "+Xp+" "+Yp+" -colors 512 c:\\GIFtemp\\*.bmp") startpath:(GetDir #maxroot)

            hiddenDOSCommand (exepath2+" --delay 3 --loop c:\\GIFtemp\\*.gif > c:\\GIFtemp\\newgif.gif" ) startpath:(GetDir #maxroot)

            try(if doesfileexist gifpath then deletefile gifpath)catch()
            try(copyfile "c:\\GIFtemp\\newgif.gif" gifpath)catch(print "파일 생성 실패-")
            try(deletefile "c:\\GIFtemp\\newgif.gif")catch(print "파일 제거 실패-")
            shellLaunch gifpath ""

            deleteFolder folderPath:"c:\\GIFtemp"
            print (timestamp()-st)
            freeSceneBitmaps(); gc()
        )

        on gifRollout open do
        (
                lbl5.text = ("사이즈:"+(sld1.value as integer) as string+"%")
                vp = getViewSize()
                a= ((vp[1]*vp[2])/125000)*((animationrange.end-animationrange.start)as integer)/(4800/framerate)/86
                b= pow (sld1.value as integer) 1.9
                c = (a*b/10000.0)
                c = formattedPrint (c) format:"0.1f"
                lbl1.text = "용량:"+c+"mb"
                edt1.text = maxfilepath+(getfilenamefile maxfilename)+maxfileNameAdd+".gif"
                gifpath = maxfilepath+(getfilenamefile maxfilename)+maxfileNameAdd+".gif"
                filename_label.text = (getfilenamefile maxfilename)+maxfileNameAdd+".gif"
            )
        on btn1 pressed  do
        (
            file_name = maxfilepath+(getfilenamefile maxfilename)
            gifpath = GetSaveFileName filename:file_name caption:"Save Gif" types:"GIF(*.gif)|*.gif|"
            if gifpath == undefined then gifpath = file_name
            edt1.text = gifpath
        )
        on sld1 changed val do
        (
                lbl5.text = ("사이즈:"+(sld1.value as integer) as string+"%")
                vp = getViewSize()
                a= ((vp[1]*vp[2])/125000)*((animationrange.end-animationrange.start)as integer)/(4800/framerate)/86
                b= pow (sld1.value as integer) 1.9
                c = (a*b/10000.0)
                c = formattedPrint (c) format:"0.1f"
                lbl1.text = "용량:"+c+"mb"
        )
        on btn9 pressed do
        (
            holdMaxFile()
            actionMan.executeAction 0 "618"
            makegif()
            fetchMaxFile quiet:true
            destroydialog gifRollout
        )

        on folderGifmaker pressed do
        (
            try (getDirPath = getSavePath caption:"소스 MAX파일 폴더 선택"() ) catch ( getDirPath = "")
            fileNameVal_str = "*"+ filterKey +"*.max"
            try (previewMaxlist = getValFileList_fn fileNameVal_str getDirPath) catch (previewMaxlist = #() )
            if previewMaxlist.count > 0 then
            (
                for i in 1 to previewMaxlist.count do
                (
                    loadmaxfile previewMaxlist[i] useFileUnits:true quiet:on
                    completeredraw()
                    gifpath = maxfilepath+(getfilenamefile maxfilename)+maxfileNameAdd+".gif"
                    actionMan.executeAction 0 "618"
                    makegif()
                )
                destroydialog gifRollout
            )
            else
            (
                messagebox "맥스파일이 없습니다."
            )
        )

    ) 

    if (doesFileExist ( "nconvert.exe") startpath:(GetDir #maxroot) == false ) do  previewRollout.gif_btn.enabled = false
    createdialog previewRollout 300 250

)
 if queryBox  "PreviewTool스크립트가 메뉴의 Customize - Customize User Interface 의 _AniSeoHyun 카테고리에 설치되었습니다. 설정창을 열겠습니까?" title:"Preview 등록" beep:false then
(
    actionMan.executeAction 0 "59226"
)
else
(

) 