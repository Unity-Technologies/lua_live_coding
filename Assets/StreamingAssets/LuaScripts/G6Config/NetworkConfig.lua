
------------------------------------------
--- NetworkConfig
--- 网络相关配置，提供使用的网络类型，网络消息定义，网络错误码定义
------------------------------------------

local NetworkConfig = 
{
	-- 网络消息定义
	NetMessageID = {},
	NetMessageName = {},
	NetMessagePath = 
	{
		"G6Framework.Game.Network.NetMessageDefine",
	},

	-- 网络消息错误码定义
	NetErrorCode = {},
	NetErrorCodeString = {},
	NetErrorCodePath = 
	{
		"G6Framework.Game.Network.NetMessageErrorCode",
	},
};

-- 提供DWA使用，其实可以合并为一个
function NetworkConfig:SetNetMessageID(tNetMessageID)
	self.NetMessageID = tNetMessageID;
end

-- 提供给DWA使用
function NetworkConfig:SetNetMessageName(tNetMessageName)
	self.NetMessageName = tNetMessageName
end

-- 注意: 消息ID <= 1000是框架保留,错误码 -1000~0是框架保留
-- 合并NetMessageID/NetErrorCode
function NetworkConfig:LoadNetworkConfig()
	-- 合并NetMessage
	for _,v in pairs(self.NetMessagePath) do
		local NetMessageConfig = require(v);
		if (type(NetMessageConfig.NetMessageID) == "table") and (type(NetMessageConfig.NetMessageName) == "table") then
			for k2,v2 in pairs(NetMessageConfig.NetMessageID) do
				if (self.NetMessageID[k2]) then
					print("NetMessage Duplcate: ",k2,v2);
				else
					self.NetMessageID[k2] = v2;
				end
			end
			for k2,v2 in pairs(NetMessageConfig.NetMessageName) do
				if (self.NetMessageName[k2]) then
					print("NetMessageName Duplcate: ",k2,v2);
				else
					self.NetMessageName[k2] = v2;
				end
			end			
		end
	end

	-- 合并NetErrorCode
	for _,v in pairs(self.NetErrorCodePath) do
		local NetErrorConfig = require(v);
		if (type(NetErrorConfig.NetErrorCode) == "table") and (type(NetErrorConfig.NetErrorCodeString) == "table") then
			for k2,v2 in pairs(NetErrorConfig.NetErrorCode) do
				if (self.NetErrorCode[k2]) then
					print("NetErrorCode Duplcate: ",k2,v2);
				else
					self.NetErrorCode[k2] = v2;
				end
			end	
			for k2,v2 in pairs(NetErrorConfig.NetErrorCodeString) do
				if (self.NetErrorCodeString[k2]) then
					print("NetErrorCodeString Duplcate: ",k2,v2);
				else
					self.NetErrorCodeString[k2] = v2;
				end
			end	
		end
	end
end	

function NetworkConfig:GetNetMessageID(strMessageKey)
	return self.NetMessageID[strMessageKey];
end

function NetworkConfig:GetNetMessageName(nMessageID)
	return self.NetMessageName[nMessageID];
end

function NetworkConfig:GetNetErrorCodeString(nNetErrorCode)
	return self.NetErrorCodeString[nNetErrorCode];
end

return NetworkConfig;