-- 프리뷰 1.1.2 gif-maker가 없을 경우 비활성화
-- 1.1.3 랜더 사이즈 오류 수정중
-- 2019-07-07 : attribute 활용
-- 2020-04-22 : 폴더 변경
-- 2021-01-25 : 프레임표시 설정 추가
macroScript PreviewTool
category:"_AniSeoHyun"
ToolTip:"PreviewTool"
icon: #("Render", 2)
(
	fn fn_getCustAttributeData =
	(
		-- custAttributes data 불러오기 및 추가ㅣ
		local dataVersion = 8
		local rootAttributCount = 1
		local getCustAttribute = "SEO_previewData"
		local m_CAData = undefined
		while (rootscene.custAttributes.count > 0 and rootscene.custAttributes.count >= rootAttributCount ) do 
		(
			local  Tempm_CAData = rootscene.custAttributes[rootAttributCount]
			if Tempm_CAData.name == getCustAttribute do m_CAData = Tempm_CAData
			rootAttributCount += 1
		)
		if (m_CAData == undefined) or (m_CAData.version < dataVersion) do
		(
			-- version은 변수로 대입이 안되네; 그래서 dataVersion의 상수를 그대로 씀.
			previewInit = attributes SEO_previewData version:8
			(
				parameters main
				(
					viewportMode               type:#string    default:#view_none 
					displayMode                type:#integer   default:2
					percentSize                type:#float     default:50
					enableDisplayFrame         type:#boolean   default:true
					isDspGrid                  type:#boolean   default:false
					isboneHide                 type:#boolean   default:true
					enableGif                  type:#boolean   default:false
					enableAvi                  type:#boolean   default:true
					renderWidth                type:#float     default:1280
					renderHeight               type:#float     default:720
				)
			)
			CustAttributes.add rootscene previewInit
			m_CAData = rootscene.SEO_previewData
		)
		m_CAData
		----
	)
	rollout previewRollout "Preview"
	(
		local m_CAData = undefined
		local getDirPath = undefined
		local previewFileName = getFilenameFile maxfileName
		local previewMaxlist = #()
		--view관련 설정
		local viewport_tag = #view_none
		local selectedLevel = #smoothhighlights
		local m_viewMode_int = 0
		local dspBones_setting = false
		local m_enableDisplayFrame = false
		local currentBone = hideByCategory.bones
		local m_currentRenderWidth = renderWidth
		local m_currentRenderHight = renderHeight
		local percentSize_setting = 25 as integer
		local fps_setting = 30 as integer
		local dspGrid_setting = false
		local CameraChack = #(false)
		local driver_chk = false
		local getNitous = undefined
		local currentVisualStyle = #Realistic
		local currentLightLevel = lightLevel
		local currentDiplaycolor =  #material
		
		fn getRederSize arg_val arg_size =
		(
			local size = arg_size * 0.01
			getVal = arg_val * arg_size
		)
		fn getValFileList_fn val_filter val_dir =
		(-- val_dir의 맥스 파일 수집
			local fileName = ""
			local maxlist = #()
			local dir = val_dir
	
			fileName = "\\"+ val_filter as string
			if dir == undefined do
			(
				return maxlist --폴더선택을 취소할 경우에는 함수에서 탈출
			)
			maxlist = getFiles (dir + fileName) -- 폴더내의 모든 맥스파일 수집
			format "\nmaxlist\n % "maxlist
	
			if maxlist.count == 0 then
			(
				messagebox "맥스파일이 없습니다." --선택한 폴더에 맥스파일이 없으면
			)
			else -- 맥스파일이 있으면
			(
				maxlist
			)
			return maxlist
		) --return maxlist #()
		fn Print_hWND_fn target_hWnd =
		(
			_ResourceID = UIAccessor.getWindowResourceID target_hWnd
			_Text = UIAccessor.GetWindowText target_hWnd
			_ClassName = UIAccessor.GetWindowClassName target_hWnd
			_data = windows.getHWNDData target_hWnd
			print "_ResourceID"
			print  _ResourceID
			print "_Text"
			print  _Text
			print "_ClassName"
			print _ClassName
			print "_data"
			print _data
		)
		fn VisualStyleSetting2018_fn =
		( 
			print "VisualStyleSetting 2018"
			WM_CHAR = 0x0102
			VK_RETURN = 0x000D
			WM_COMMAND = 0x111
			CB_SETCURSEL = 0x014E
			CBN_SELENDOK = 1
			local resourceID_preference = 1472
			local resourceID_boneObject = 1199
			local test_resourceID_Perspective = 1595
			
			local viewMode2018_int = 0
			case of 
			(	
				(m_viewMode_int == 7) :
				(
					viewMode2018_int = 2
				)
				default :
				(
					viewMode2018_int = 0
				)
			)
	
			local hWND = DialogMonitorOPS.GetWindowHandle()
			if ((UIAccessor.GetWindowText hWND) == "Make Preview") do 
			( -- http://forums.cgsociety.org/archive/index.php?t-1073040.html
				-- Print_hWND_fn hWND
				child_hWND = UIAccessor.GetChildWindows hWND
				for obj_hWND in child_hWND do
				(
					-- Print_hWND_fn obj_hWND
					targetId = UIAccessor.getWindowResourceID obj_hWND
					case of 
					(
						(targetId == resourceID_preference ) :
							(
								windows.sendMessage obj_hWND CB_SETCURSEL viewMode2018_int 0
								windows.sendMessage hWND WM_COMMAND ((bit.shift CBN_SELENDOK 16) + targetId) obj_hWND
							)
						(targetId == test_resourceID_Perspective) :
							(
								--Print_hWND_fn obj_hWND
								--aaa = windows.getHWNDData obj_hWND
								
							)
					)
				)
				UIAccessor.pressbuttonbyname hWND "Cancel"
				--UIAccessor.pressbuttonbyname hWND "Create"
				completeRedraw()
			)
			true
		)
		fn VisualStyleSetting_fn =
		( -- dspBones_setting
			print "VisualStyleSetting 2018 미만"
			WM_CHAR = 0x0102
			VK_RETURN = 0x000D
			WM_COMMAND = 0x111
			CB_SETCURSEL = 0x014E
			CBN_SELENDOK = 1
			print m_viewMode_int
	
			local hWND = DialogMonitorOPS.GetWindowHandle()
			if ((UIAccessor.GetWindowText hWND) == "Make Preview") do
			( -- http://forums.cgsociety.org/archive/index.php?t-1073040.html
				--fn_print_hWND hWND
				child_hWND = UIAccessor.GetChildWindows hWND
				for obj_hWND in child_hWND do
				(
					--fn_print_hWND i
					if ((UIAccessor.GetWindowText obj_hWND) == "Preference") do
					(
						target_hWnd = UIAccessor.GetNextWindow obj_hWND
						--fn_print_hWND target_hWnd
						target_hWnd1 = UIAccessor.GetNextWindow target_hWnd
						targetId = UIAccessor.getWindowResourceID target_hWnd1
						--fn_print_hWND target_hWnd1
						--fn_print_hWND target_hWnd
						windows.sendMessage target_hWnd1 CB_SETCURSEL m_viewMode_int 0
						--windows.sendmessage hWND WM_CHAR VK_RETURN 0
						windows.sendMessage hWND WM_COMMAND ((bit.shift CBN_SELENDOK 16) + targetId) target_hWnd1
						--windows.sendMessage hWND WM_COMMAND VK_RETURN target_hWnd1
						--print "=========sendmessage=========="
						--fn_print_hWND target_hWnd1
					)
					if ((UIAccessor.GetWindowText obj_hWND) == "Display Filter") do 
						(
							target_hWnd = UIAccessor.GetNextWindow obj_hWND
							--fn_print_hWND target_hWnd
							target_hWnd1 = UIAccessor.GetNextWindow target_hWnd
							targetId = UIAccessor.getWindowResourceID target_hWnd1
							--fn_print_hWND target_hWnd1
							--windows.sendMessage target_hWnd1 CB_SETCURSEL m_viewMode_int 0
							--windows.sendMessage hWND WM_COMMAND ((bit.shift CBN_SELENDOK 16) + targetId) target_hWnd1
							--print "=========sendmessage=========="
							--fn_print_hWND target_hWnd1
						)
				)
				UIAccessor.pressbuttonbyname hWND "Cancel"
				--UIAccessor.pressbuttonbyname hWND "Create"
				completeRedraw()
				true
			)
		)
		fn PreviewExport_fn createGif createAvi=
		( --1.3.3 버전용 --driver_chk
			print "PreviewExport_fn start"
			local MaxDefaultPreviewFile
			local TargetFolder
			local TargetPreviewFileName
			local currentPath = (GetDir #userscripts + "\\SEO\\SEO_Preview")
			renderWidth = 1920
			renderHeight =  1080
			renderPixelAspect = 1.00000
			percentSize_setting = previewRollout.percentSize_spinner.value
			--if driver_chk == true do getNitous.UseEnvironmentBackgroundColorEnabled = false
			--
			print "dialogMonitorOps"
			DialogMonitorOPS.enabled = true
			getMaxVarsion = (maxversion())[1]/1000+1998
			if getMaxVarsion < 2018 then
			(
				-- print "2018버전 미만"
				DialogMonitorOPS.registerNotification VisualStyleSetting_fn id:#previewSetting
				max preview
				--actionMan.executeAction 0 "60010"  -- Render: Render SetUp...
				DialogMonitorOPS.unRegisterNotification id:#previewSetting
				
			)
			else 
			(
				-- print "2018버전 이상"
				DialogMonitorOPS.registerNotification VisualStyleSetting2018_fn id:#previewSetting
				max preview
				--actionMan.executeAction 0 "60010"  -- Render: Render SetUp...
				DialogMonitorOPS.unRegisterNotification id:#previewSetting
			)
			DialogMonitorOPS.enabled = false
			--return()
			MaxDefaultPreviewFile = ((getdir #preview) + "\\_scene.avi" )
			-- 이전파일과 머쥐 되는 현상이 있어서 우선 삭제 시켜줌.
			deleteFile MaxDefaultPreviewFile
			TargetFolder = maxfilepath
			-- 2019-03-12 FFmpeg
			--TargetPreviewFileName = ((getFilenameFile maxFileName) + ".avi" )
			TargetPreviewFileName = (previewFileName + ".mp4" )
			--
			if getMaxVarsion < 2020 then
			(
				createPreview percentSize:percentSize_setting start:(animationRange.start.frame as integer) end:(animationRange.end.frame as integer)  fps:fps_setting dspBones:dspBones_setting
			)
			else
			(
				createPreview percentSize:percentSize_setting start:(animationRange.start.frame as integer) end:(animationRange.end.frame as integer)  fps:fps_setting dspBones:dspBones_setting dspFrameNums:m_enableDisplayFrame filename:MaxDefaultPreviewFile 
			)
			if createAvi do
			(
				/* 2019-03-12백업
				deleteFile (TargetFolder + TargetPreviewFileName)
				copyFile MaxDefaultPreviewFile (TargetFolder + TargetPreviewFileName)
				*/
				-- 2019-03-12 FFmpeg mp4만들기
				print "--createAvi--"
				print "MaxDefaultPreviewFile : " + MaxDefaultPreviewFile
				print "TargetPreviewFileName :" + TargetPreviewFileName
				print "currentPath : " + currentPath
				local tmepgifFileName = "Temp.mp4"
				outputFilePath = pathConfig.appendPath TargetFolder TargetPreviewFileName
				tempFilePath = pathConfig.appendPath currentPath tmepgifFileName
				-- 기존 파일 삭제
				deleteFile outputFilePath
				deleteFile tempFilePath
				--hiddenDOSCommand ("ffmpeg.exe -i " + MaxDefaultPreviewFile + " -y " + tmepgifFileName ) startpath:currentPath
				-- h264규격
				isFile = hiddenDOSCommand ("ffmpeg.exe -r 30 -i \"" + MaxDefaultPreviewFile + "\" -vcodec libx264 -crf 1 -pix_fmt yuv420p -y " + tmepgifFileName ) startpath:currentPath
				if isFile do print "Create Temp.mp4"
				if doesFileExist tempFilePath do print "is Temp.mp4"
				copyFile tempFilePath outputFilePath
			)
			if createGif do
			(
				print ("Gif 실행 \n")
				local gifFilePaht = (TargetFolder + previewFileName + ".gif")
				local tmepgifFileName = "Temp.gif"
				local tmepgifFileNameAndPaht = (currentPath + "\\"+tmepgifFileName)
				local palettTempFileName = "palettFile.png"
				local 필터내용 = " -y -filter_complex paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle "
				hiddenDOSCommand ("ffmpeg.exe -i \""+ MaxDefaultPreviewFile + "\" -y -vf fps=15,scale=400:-1:flags=lanczos,palettegen=stats_mode=diff palettFile.png") startpath:currentPath
				hiddenDOSCommand ("ffmpeg.exe -i \""+ MaxDefaultPreviewFile + "\" -i " + palettTempFileName + 필터내용 + tmepgifFileName ) startpath:currentPath
				deleteFile gifFilePaht
				copyFile tmepgifFileNameAndPaht gifFilePaht
				deleteFile tmepgifFileNameAndPaht
			)
        )
		fn getNitous_setting =
		(
			driver_chk = NitrousGraphicsManager.IsEnabled()
			if driver_chk == true do
			(
				getNitous = NitrousGraphicsManager.GetActiveViewportSetting()
				NitrousGraphicsManager.GesturaEnabled = true
				NitrousGraphicsManager.MakePreviewQuality = 16
				currentVisualStyle = getNitous.VisualStyleMode
				print currentVisualStyle
			)
		)
		fn DisplaySelect_fn arg_int =
		(
			case arg_int of
			(
				1:
				(
					if driver_chk == true do
					(
						getNitous.VisualStyleMode = #Realistic
					)
					displayColor.shaded = #object
					m_viewMode_int = 1
					lightLevel = 1
				)
				2:
				(
					if driver_chk == true do
					(
						getNitous.VisualStyleMode = #Realistic
					)
					displayColor.shaded = #material
					m_viewMode_int = 0
					lightLevel = currentLightLevel
				)
				3:
				(
					if driver_chk == true then
					(
						m_viewMode_int = 7
						getNitous.VisualStyleMode = #Clay
						lightLevel = currentLightLevel
					)
					else
					(
						messagebox "display 설정이 지원하지 않습니다."
						previewRollout.display_select.state = 2
					)
				)
				default:
				(
					if driver_chk == true do
					(
						getNitous.VisualStyleMode = #Realistic
					)
					displayColor.shaded = #material
					m_viewMode_int = 0
					lightLevel = currentLightLevel
					previewRollout.display_select.state = 2
				)
			)
		)
		group "Satting"
		(
			checkbox dspBones_checkbox "Hide Bone" offset:[0,5] across:3
			spinner	percentSize_spinner "1920*1080" range:[0, 100, percentSize_setting] type:#integer scale:1 fieldWidth:32 offset:[75,5]
			label percent "%" offset:[40,5]
			checkbox createGif "gif" offset:[0,0] checked:false across:4
			checkbox createAvi "mp4" offset:[0,0] checked:true
			checkbox 재생하기 "자동재생" offset:[0,0]
			checkbox ui_openFolderAuto "폴더열기" offset:[0,0]
			label 재생하기text "자동재생은 맥스 기본 AutoPlay와 중복재생됨." offset:[0,0]
			label 재생하기경고text2 "Folder를 선택시 AutoPlay Preview File을 꺼주세요." offset:[0,0]
			--checkbox displayColor_checkbox "Object Color" offset:[0,5]
			--checkbox percentSize_checkbos "비활성화" offset:[0,5]
			radiobuttons display_select labels:#("Color","Material","Clay") default:2 columns:3 across:2 offset:[20,0]
			button saveSetting_btn "설정 저장" offset:[20,0] tooltip:"설정을 파일별로 저장"
			checkbox ui_enableDisplayFrame "Fps 표시" offset:[0,0]
	
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
			on display_select changed state do
			(
				DisplaySelect_fn state
			)
			on ui_enableDisplayFrame changed state do
			(
				m_enableDisplayFrame =  state
			)
			on percentSize_spinner changed state do
			(
				percentSize_setting = percentSize_spinner.range[3] as integer
			)
			on saveSetting_btn pressed do 
			(
				m_CAData.percentSize = percentSize_spinner.value
				m_CAData.isboneHide = dspBones_checkbox.state
				m_CAData.enableGif = createGif.state
				m_CAData.enableAvi = createAvi.state
				m_CAData.displayMode = display_select.state
				m_CAData.enableDisplayFrame = ui_enableDisplayFrame.state
				max hold
			)
		)
		group "Export run"
		(
			button exportMaxFile_btn "파일 경로 열기" width:80 offset:[-85, 0]
			button previewFolderExport_btn "Folder 만들기" width:80 offset:[0, -26.5]
			button previewFileExport_btn "File 만들기" width:80 offset:[85, -26.5]
			edittext previewFileName_edit "파일명:" text:previewFileName width:275
			on previewFileName_edit entered txt do
			(
				previewFileName = txt
			)
			on previewFileExport_btn pressed do
			(--PreviewExport_fn
				local previewNow
				PreviewExport_fn createGif.state createAvi.state
				if 재생하기.state and createGif.state do
				(
					previewNow = (maxfilepath + previewFileName + ".gif")
					ShellLaunch previewNow ""
				)
				if 재생하기.state and createAvi.state do
				(
					previewNow = (maxfilepath + previewFileName + ".mp4")
					ShellLaunch previewNow ""
				)
				if ui_openFolderAuto.state do 
				(
					ShellLaunch maxfilepath ""
				)
				DestroyDialog previewRollout
			)
			on exportMaxFile_btn pressed do
			(
				ShellLaunch maxfilepath ""
			)
			on previewFolderExport_btn pressed do
			(--getValFileList_fn --PreviewExport_fn
				getDirPath = getSavePath caption:"AutoPlay Preview File을 꺼주세요." initialDir:maxfilepath -- 폴더 선택
				fileNameVal_str = "*@*.max"
				previewMaxlist = getValFileList_fn fileNameVal_str getDirPath
				format "\n previewFolderExport_btn previewMaxlist \n %" previewMaxlist
	
				if previewMaxlist.count > 0 do
				(
					for obj in previewMaxlist do
					(
						loadmaxfile obj useFileUnits:true quiet:true -- 파일을 열때 물어보는것 없이 연다.
						completeredraw()
						PreviewExport_fn createGif.state createAvi.state
					)
				)
			) -- PreviewExport_fn()
		)
		on previewRollout open do
		( --Update
			m_CAData = fn_getCustAttributeData()
			getNitous_setting()
			currentBone = hideByCategory.bones
			currentLightLevel = lightLevel
			currentDiplaycolor = displayColor.shaded
			currentSefeFrame = displaySafeFrames
			previewFileName = getFilenameFile maxfileName
			--
			m_currentRenderWidth = renderWidth
			m_currentRenderHight = renderHeight
			renderWidth = 1920
			renderHeight = 1080
			percentSize_spinner.value = m_CAData.percentSize
			percentSize_setting = percentSize_spinner.value
			hideByCategory.bones = m_CAData.isboneHide --기본값으로 본을 숨겨줌
			dspBones_checkbox.state = hideByCategory.bones
			createGif.state = m_CAData.enableGif
			createAvi.state = m_CAData.enableAvi
			display_select.state = m_CAData.displayMode
			-- 8버전부터 있는 값
			if m_CAData.version > 7 do 
			(
				ui_enableDisplayFrame.state = m_CAData.enableDisplayFrame
				m_enableDisplayFrame = m_CAData.enableDisplayFrame
			)
			DisplaySelect_fn display_select.state
			if (displaySafeFrames == false) do 	max safeframe toggle
			--if driver_chk == true do
			--(
			--	getNitous.VisualStyleMode = #Realistic
			--)
			--displayColor.shaded = #material
		)
		on previewRollout close do
		(
			renderWidth = m_currentRenderWidth
			renderHeight = m_currentRenderHight
			
			lightLevel = currentLightLevel
			hideByCategory.bones = currentBone
			displayColor.shaded = currentDiplaycolor
			if driver_chk == true do
			(
				getNitous.VisualStyleMode = currentVisualStyle
			)
			if (currentSefeFrame == true) then
			(
				if (displaySafeFrames == false) do	max safeframe toggle
			)
			else
			(
				if (displaySafeFrames == true) do	max safeframe toggle
			)
		)
	)
	createdialog previewRollout 300 250
)
 if queryBox  "PreviewTool스크립트가 메뉴의 Customize - Customize User Interface 의 _AniSeoHyun 카테고리에 설치되었습니다. 설정창을 열겠습니까?" title:"Preview 등록" beep:false then
(
	actionMan.executeAction 0 "59226"
)
else
(

) 
