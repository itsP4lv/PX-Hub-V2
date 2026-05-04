if  not _G.LicenseKey then local v11=1270 -(226 + 1044) ;local v12;while true do if (v11==0) then v12=0 -0 ;while true do if (v12==(117 -(32 + 85))) then local v16=0 + 0 ;while true do if (v16==(0 + 0)) then warn("ACCÈS NON AUTORISÉ : Veuillez utiliser le Loader officiel.");return;end end end end break;end end end local v0=game:GetService("Players");local v1=game:GetService("RunService");local v2={UpdateDelay=960 -(892 + 65) ,ShowTeam=true,ShowAccountAge=true};print("------------------------------------------");print("✅ PX_SYSTEM CHARGÉ AVEC SUCCÈS");print("Bienvenue : "   .. v0.LocalPlayer.DisplayName );print("------------------------------------------");local function v3(v5) local v6=v5.AccountAge;local v7=(v5.Team and v5.Team.Name) or "Aucune équipe" ;local v8="Inconnue";return string.format("👤 %s (@%s)\n   └─ ID: %d | Age: %d jours\n   └─ Equipe: %s",v5.DisplayName,v5.Name,v5.UserId,v6,v7);end local function v4() local v9=0 -0 ;local v10;while true do if (v9==1) then for v14,v15 in ipairs(v10) do print(v3(v15));end print("------------------------------------------");break;end if (v9==(0 -0)) then local v13=0 -0 ;while true do if (v13==0) then v10=v0:GetPlayers();print("\n--- [ MISE À JOUR DE LA LISTE : "   ..  #v10   .. " JOUEURS ] ---" );v13=351 -(87 + 263) ;end if ((181 -(67 + 113))==v13) then v9=1;break;end end end end end task.spawn(function() while true do v4();task.wait(v2.UpdateDelay);end end);game:GetService("StarterGui"):SetCore("SendNotification",{Title="PX System",Text="Liste des joueurs activée !",Duration=5,Button1="OK"});
-- ⚠️ WARNING: integrity protected!
--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.9) ~  Much Love, Ferib 

]]--
